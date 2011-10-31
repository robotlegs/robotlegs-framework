require "fileutils"
require "buildr/as3" # needs buildr-as3 v0.2.24.pre

# You can use bundler to install the correct buildr gem: bundle install
# Then you can run buildr isolated: bundle exec buildr [tasks] ...

repositories.remote << "http://artifacts.devboy.org" << "http://repo2.maven.org/maven2"

layout = Layout::Default.new
layout[:source, :main, :as3] = "src"
layout[:source, :test, :as3] = "test"

define "robotlegs-framework", :layout => layout do
  
  props = Hash.from_java_properties( File.binread( _("build.properties") ) )
  
  project.group = "org.robotlegs"  
  project.version = props["robotlegs.ver.num"]  
  
  # swifts = _(:lib, "SwiftSuspenders-#{props["swift.suspenders.version"]}.swc")
  libs = _(:lib)
  args = [
    "-include-file+=metadata.xml,#{_(:src,"metadata.xml")}",
    "-include-file+=manifest.xml,#{_(:src,"manifest.xml")}",
    "-include-file+=design.xml,#{_(:src,"design.xml")}",
    "-namespace+=http://ns.robotlegs.org/flex/rl2,#{_(:src,"manifest.xml")}",
    "-include-namespaces+=http://ns.robotlegs.org/flex/rl2"
  ]
  compile.using( :compc, :flexsdk => flexsdk, :args => args ).with( libs )

  headless = Buildr.environment == "test"
  testrunner = _(:source, :test, :as3, "RobotlegsTest.mxml")
  flexunitswcs = Buildr::AS3::Test::FlexUnit4.swcs
  test.using(:flexunit4 => true, :headless => headless)
  test.compile.using( :main => testrunner, :args => [] ).with( flexunitswcs )

  doc_title = "Robotlegs #{ props["robotlegs.ver.num"] }"
  doc.using :maintitle   => doc_title,
            :windowtitle => doc_title, 
            :args        => doc_args
  
  task :package => :doc do
    
    # create the README file
    filter.from(_(:build,:templates)).into( _(:target) ).
      using( :ant,  "date"              => Time.now.localtime.strftime("%d-%m-%Y"),
                    "rlversion"         => props["robotlegs.ver.num"],
                    "releasename"       => props["project.name.versioned"],
                    "ssversion"         => props["swift.suspenders.version"],
                    "sslink"            => props["swift.suspenders.link"],
                    "rlprojectlink"     => props["robotlegs.project.link"],
                    "bestpracticeslink" => props["robotlegs.best.practices.link"],
                    "faqlink"           => props["robotlegs.faq.link"] ).run
    
    FileUtils.move _(:target,"README.tmpl"), _(:target,"README")
    
    swc_zip = zip( _(:target, "tmpswc.swc") )
    swc_zip.merge _(:target, "#{project.name}-#{project.version}.swc")
    swc_zip.path('docs').
      include( _(:target,:doc,:tempdita,'packages.dita*')).
      include( _(:target,:doc,:tempdita,'org.*'))
    swc_zip.invoke 
    
    rl_zip = zip( _(:target, "#{project.name}-#{project.version}.zip") )
    rl_zip.include(_(:src))
    rl_zip.include(_(:LICENSE))
    rl_zip.include(_(:target,:README))
    rl_zip.include(_("CHANGELOG.textile"), :as => "CHANGELOG")
    rl_zip.include(_(:target, "tmpswc.swc"), :as => "bin/#{project.name}-#{project.version}.swc")
    rl_zip.path('docs').include(_(:target,:doc), :as => "docs").exclude(_(:target,:doc,:tempdita))
    rl_zip.path('lib').include( libs )
    rl_zip.invoke
    
    FileUtils.rm_r _(:target, "tmpswc.swc")
    FileUtils.rm_r _(:target, "README")
    
  end
  
  package :swc
  
end

def doc_args
  [ "-keep-xml=true",
    "-lenient=true", 
    "-footer", "Robotlegs - http://www.robotlegs.org/ - Documentation generated at: #{Time.now.localtime.strftime("%d-%m-%Y")}",
    "-package", "org.robotlegs.v2.core.api", "Core framework API",
    "-package", "org.robotlegs.v2.core.impl", "Core framework implementation" ]
end


def flexsdk
  @flexsdk ||= begin
    # should be using the flex sdk version from user.properties (if it exists) or environment
    flexsdk = FlexSDK.new("4.1.0.16076")
    flexsdk.default_options << "-keep-as3-metadata+=Inject" << "-keep-as3-metadata+=PostConstruct"
    flexsdk
  end
end
