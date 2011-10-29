require "buildr/as3"

PROPERTIES = Hash.from_java_properties( File.binread("build.properties") )

layout = Layout::Default.new
layout[:source, :main, :as3] = "src"
layout[:source, :test, :as3] = "test"

FLEX_SDK = FlexSDK.new("4.5.0.20967")
FLEX_SDK.default_options << "-keep-as3-metadata+=Inject" << "-keep-as3-metadata+=PostConstruct"

THIS_VERSION = "1.4.0"

define "robotlegs-framework", :layout => layout do

  project.group = "org.robotlegs"  

  swcs = _(:build, :libs, "SwiftSuspenders-v1.5.1.swc")
  args = ["-include-file=metadata.xml,#{_(:source,:main,:as3,"metadata.xml")}"]
  compile.using( :compc, :flexsdk => FLEX_SDK, :other => args ).with( swcs )

  testrunner = _(:source, :test, :as3, "RobotlegsTest.mxml")
  testswcs = Buildr::AS3::Test::FlexUnit4.swcs
  test.using(:flexunit4 => true).compile.using(:main => testrunner).with( testswcs )

  doc.using :flexsdk => FLEX_SDK
  package :swc

end

define "robotlegs" do

  project.version = RLVERSION

  package(:zip).
      include( project("robotlegs-framework"), :path => "libs" )

end
