require "fileutils"
require "buildr/as3" #needs buildr-as3 v0.2.23.pre

layout = Layout::Default.new
layout[:source, :main, :as3] = "src"
layout[:source, :test, :as3] = "test"

define "robotlegs-framework", :layout => layout do

  props = Hash.from_java_properties( File.binread( _("build.properties") ) )
  puts props

  project.group = "org.robotlegs"  
  project.version = props["robotlegs.ver.num"]  

  swifts = _(:build, :libs, "SwiftSuspenders-#{props["swift.suspenders.version"]}.swc")
  args = ["-include-file=metadata.xml,#{_(:source,:main,:as3,"metadata.xml")}"]
  compile.using( :compc, :flexsdk => flexsdk, :other => args ).with( swifts )

  testrunner = _(:source, :test, :as3, "RobotlegsTest.mxml")
  flexunitswcs = Buildr::AS3::Test::FlexUnit4.swcs
  test.using(:flexunit4 => true).compile.using(:main => testrunner, :other => []).with( flexunitswcs )

  doc_title = "Robotlegs #{ props["robotlegs.ver.num"] }"
  doc.using :maintitle => doc_title,
            :windowtitle => doc_title, 
            :args => doc_args
  
  task :package => :doc do

    # create the README file
    filter.from(_(:build,:templates)).into( _(:target) ).
      using( :ant,  "date" => Time.now.localtime.strftime("%d-%m-%Y"),
                    "rlversion" => props["robotlegs.ver.num"],
                    "releasename" => props["project.name.versioned"],
                    "ssversion" => props["swift.suspenders.version"],
                    "sslink" => props["swift.suspenders.link"],
                    "rlprojectlink" => props["robotlegs.project.link"],
                    "bestpracticeslink" => props["robotlegs.best.practices.link"],
                    "faqlink" => props["robotlegs.faq.link"] ).run

    FileUtils.move _(:target,"README.tmpl"), _(:target,"README")

    swc_zip = zip( _(:target, "tmpswc.swc") )
    swc_zip.merge _(:target, "#{project.name}-#{project.version}.swc")
    swc_zip.path('docs').
      include( _(:target,:doc,:tempdita,'packages.dita*')).
      include( _(:target,:doc,:tempdita,'org.*'))
    swc_zip.invoke 

    rl_zip = zip( _(:target, "#{project.name}-#{project.version}.zip") )
    rl_zip.include(_(:target,:README))
    rl_zip.include(_(:target, "tmpswc.swc"), :as => "bin/#{project.name}-#{project.version}.swc")
    rl_zip.include(_())
    rl_zip.path('docs').include(_(:target,:doc), :as => "docs").exclude(_(:target,:doc,:tempdita))
    rl_zip.path('lib').include( swifts )
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
    "-package", "org.robotlegs.adapters", "Adapters to bridge third-party Di/IoC and reflection libraries",
    "-package", "org.robotlegs.base", "Base classes used to build custom Robotlegs frameworks",
    "-package", "org.robotlegs.core", "The core Robotlegs Framework apparatus contracts",
    "-package", "org.robotlegs.mvcs", "The reference MVCS Robotlegs Framework implementation" ]
end

def flexsdk
  @flexsdk ||= begin
    flexsdk = FlexSDK.new("4.5.1.21328")
    flexsdk.default_options << "-keep-as3-metadata+=Inject" << "-keep-as3-metadata+=PostConstruct"
    flexsdk
  end
end

def layout
  @layout ||= begin
  end
end