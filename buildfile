require "fileutils"
require "buildr/as3" # needs buildr-as3 v0.2.30.pre

# You can use bundler to install the correct buildr gem: bundle install
# Then you can run buildr isolated: bundle exec buildr [tasks] ...

repositories.remote << "http://artifacts.devboy.org" << "http://repo2.maven.org/maven2"
repositories.release_to[:url] = 'http://snapshot.artifacts.devboy.org/'
repositories.release_to[:username] = ENV["ruser"]
repositories.release_to[:password] = ENV["rpass"]

layout = Layout::Default.new
layout[:source, :main, :as3] = "src"
layout[:source, :test, :as3] = "test"

THIS_VERSION = "2.1.0-SNAPSHOT"

define "robotlegs-framework", :layout => layout do

  project.group = "org.robotlegs"
  project.version = THIS_VERSION

  args = [
    "-namespace+=http://ns.robotlegs.org/flex/rl2,#{_(:src,"manifest.xml")}",
    "-include-namespaces+=http://ns.robotlegs.org/flex/rl2"
  ]

  compile.using( :compc, :flexsdk => flexsdk, :args => args ).
    with( _(:lib,"Swiftsuspenders-v2.0.0rc3.swc"),
          _(:lib,"hamcrest-as3-flex-1.1.3.swc") )

  testrunner = _(:source, :test, :as3, "RobotlegsTest.mxml")
  test.using(:flexunit4 => true, :headless => false, :version => "4.1.0-8")

  test.compile.using( :main => testrunner, :args => [] ).
    with( FlexUnit4.swcs("4.1.0-8", "4.1.0.16076", :flex),
          _(:lib,"mockolate-0.12.4-flex.swc"),
          _(:lib,"hamcrest-as3-flex-1.1.3.swc") )

  doc_title = "Robotlegs v#{THIS_VERSION}"
  doc.using :maintitle   => doc_title,
            :windowtitle => doc_title,
            :args        => doc_args

  task package => doc

  package(:swc).
    include( _(:src,"*.xml") ).
    path('docs').
       include( _(:target,:doc,:tempdita,'packages.dita*') ).
       include( _(:target,:doc,:tempdita,'robotlegs.*') )


end

desc "Creates a zip archive containing a swc, sources, libraries and documentation."
task :archive => "robotlegs-framework:doc" do

    rl = project( "robotlegs-framework" )
    rl_swc = artifacts( rl ).first
    rl_vname = File.basename( rl_swc.to_s, ".swc" )
    rl_zip = rl._(:target, "#{rl_vname}.zip")

    filter.from(rl._(:build,:templates)).into( rl._(:target) ).
      using( :ant,  "date"              => Time.now.localtime.strftime("%d-%m-%Y"),
                    "rlversion"         => THIS_VERSION,
                    "releasename"       => File.basename( rl_swc.to_s, "swc" ),
                    "ssversion"         => THIS_VERSION,
                    "sslink"            => "http://github.com/tschneidereit/SwiftSuspenders",
                    "rlprojectlink"     => "http://github.com/robotlegs/robotlegs-framework",
                    "bestpracticeslink" => "http://github.com/robotlegs/robotlegs-framework/wiki/Best-Practices",
                    "faqlink"           => "http://knowledge.robotlegs.com" ).run

    FileUtils.move rl._(:target,"README.tmpl"), rl._(:target,"README")

    puts "Packaging archive in #{rl_zip}"

    rl_zip = zip( rl_zip )
    rl_zip.include(rl._(:src))
    rl_zip.include(rl._(:LICENSE))
    rl_zip.include(rl._(:target,:README))
    rl_zip.include(rl._("changelog.md"), :as => "changelog.txt")
    rl_zip.path('bin').include( rl_swc )
    rl_zip.path('docs').include( rl._(:target,:doc), :as => "docs" ).exclude( rl._(:target,:doc,:tempdita) )
    rl_zip.include( rl._(:lib) )
    rl_zip.invoke

    FileUtils.rm_r rl._(:target, "README")
end

def doc_args
  [ "-keep-xml=true",
    "-lenient=true",
    "-footer", "Robotlegs - http://www.robotlegs.org/ - Documentation generated at: #{Time.now.localtime.strftime("%d-%m-%Y")}",
    "-package", "robotlegs.bender.core.api", "Core framework API",
    "-package", "robotlegs.bender.core.impl", "Core framework implementation" ]
end


def flexsdk
  @flexsdk ||= begin
    # should be using the flex sdk version from user.properties (if it exists) or environment
    flexsdk = FlexSDK.new("4.5.1.21328")
    flexsdk.default_options << "-keep-as3-metadata+=Inject" << "-keep-as3-metadata+=PostConstruct"
    flexsdk
  end
end
