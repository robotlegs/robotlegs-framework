Dir.glob('rakefiles/*.rb').each { |r| import r }

require 'sprout'
# Optionally load gems from a server other than rubyforge:
# set_sources 'http://gems.projectsprouts.org'
sprout 'as3'

############################################
# Configure your Project Model
project_model :model do |m|
  m.project_name            = 'Robotlegs2'
  m.language                = 'as3'
  m.background_color        = '#FFFFFF'
  m.width                   = 970
  m.height                  = 550
  # m.use_fdb               = true
  # m.use_fcsh              = true
  # m.preprocessor          = 'cpp -D__DEBUG=false -P - - | tail -c +3'
  # m.preprocessed_path     = '.preprocessed'
  # m.src_dir               = 'src'
  # m.lib_dir               = 'lib'
  # m.swc_dir               = 'lib'
  # m.bin_dir               = 'bin'
  # m.test_dir              = 'test'
  # m.doc_dir               = 'doc'
  # m.asset_dir             = 'assets'
  m.compiler_gem_name     = 'sprout-flex4sdk-tool'
  m.compiler_gem_version  = '>= 4.0.0'
  m.library_path          << 'lib/hamcrest-as3-flex-1.1.3.swc'
  m.library_path          << 'lib/Swiftsuspenders-v2.0.0rc3.swc'
  m.library_path          << 'lib/mockolate-0.12.4-flex.swc'
  m.library_path          << 'lib/corelib.swc/corelib.swc' 
  m.support_dir           = 'support'    
end

desc 'Compile and debug the application'
debug :debug

desc 'Compile run the test harness'
unit :test do |t|
  t.input = 'test/RobotlegsTest.mxml'
  t.debug = true
  t.library_path  << 'lib/flexunit-4.1.0-8-flex_4.1.0.16076.swc'
  t.library_path  << 'lib/flexunit-cilistener-4.1.0-8-4.1.0.16076.swc'
  t.library_path  << 'lib/fluint-extensions-4.1.0-8-4.1.0.16076.swc'
end

desc 'Compile the optimized deployment'
deploy :deploy

desc 'Create documentation'
document :doc

desc 'Compile a SWC file'
swc :swc

desc 'Compile and run the test harness for CI'
ci :cruise

# set up the default rake task
task :default => :test