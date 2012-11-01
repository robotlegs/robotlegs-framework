require 'find'

extension = "as"

if ARGV.length < 1
  raise ArgumentError.new('argument required: path to folder to look in for .as files')
end

path = ARGV[0]

withASDoc = false
if ARGV.length == 2
  withASDoc = (ARGV[1] == 'true')
end

qualification = withASDoc ? '' : 'do not '

puts "The following files and public functions " + qualification + "appear to have ASDoc comments"

Find.find(path) do |f|
  if File.file?(f) && File.fnmatch('*.' + extension, f)
    previous_line = ""
    api_functions = []
    File.new(f, "r").each do |line|
      if((line.include? "public function") && ((previous_line.include? "*/") == withASDoc) )
        function_name = line.scan(/public function (.+)\(/)[0]
        if(function_name == nil)
          api_functions.push(line)
        else
          api_functions.push(function_name)
        end
      end
      previous_line = line
    end
    if(!api_functions.empty?)
      puts ""
      puts ".#{f}"
      api_functions.each do |function_name|
        puts "    -> #{function_name}"
      end
    end
  end
end       
