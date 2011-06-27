
class SupportGenerator < Sprout::Generator::NamedBase  # :nodoc:
  
  # Support class name - auto generated to className + Support if not specified
  attr_reader :support_class_name

  def manifest
    record do |m|
      
      if(ARGV.size == 2)
        @support_class_name = class_name + ARGV[1]
      else
        @support_class_name = class_name + 'Support'
      end
      
      full_support_dir = full_class_dir.gsub(src_dir, model.support_dir)
      m.directory full_support_dir
      m.template 'Support.as', full_support_dir + '/' + support_class_name + '.as'
      
    end
  end
  
    
end
