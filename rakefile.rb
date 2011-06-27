Dir.glob('rakefiles/*.rb').each { |r| import r }

require 'sprout'
# Optionally load gems from a server other than rubyforge:
# set_sources 'http://gems.projectsprouts.org'
sprout 'as3'

############################################
# Configure your Project Model
project_model :model do |m|
  m.project_name            = 'ViewManagerExperiments'
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
  # m.source_path           << "#{m.lib_dir}/somelib"
  m.source_path           << "#{m.lib_dir}/mockolate"  
  m.library_path          << 'lib/asx.swc'
  m.library_path          << 'lib/hamcrest.swc'
  m.library_path          << 'lib/FLoxy.swc'
  # m.libraries             << :corelib 
  m.support_dir           = 'support'    
end

desc 'Compile and debug the application'
debug :debug

desc 'Compile run the test harness'
unit :test

desc 'Compile the optimized deployment'
deploy :deploy

desc 'Create documentation'
document :doc

desc 'Compile a SWC file'
swc :swc

desc 'Compile and run the test harness for CI'
ci :cruise

# set up the default rake task
task :default => :debug
