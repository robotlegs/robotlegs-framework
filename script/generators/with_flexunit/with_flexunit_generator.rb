class WithFlexunitGenerator < Sprout::Generator::NamedBase  # :nodoc:

  def manifest
    record do |m|
#      m.class_collisions class_dir, "#{class_name}Controller", "#{class_name}ControllerTest", "#{class_name}Helper"

      if(!user_requested_test)
        m.directory full_class_dir
        m.template 'Class.as', full_class_path
      end
 
      m.directory full_test_dir
      m.template 'TestCase.as', full_test_case_path
    end
  end
    
end
