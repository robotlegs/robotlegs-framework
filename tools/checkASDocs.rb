require 'find'

if ARGV.length < 1
  raise ArgumentError.new('argument required: path to folder to look in for .as files')
end

withASDoc = ARGV.length == 2 \
  ? ARGV[1] == 'true' : false

qualification = withASDoc ? '' : 'do not '
puts "The following files and public functions " + qualification + "appear to have ASDoc comments"

def relevant_files(path)
  Find.find(path).select do |f|
    File.file?(f) && File.fnmatch('*.as', f)
  end
end

def relevant_line(line, previous_line, withASDoc)
  (line.include?("public function") || line.include?("public class") || line.include?("public interface")) \
    && previous_line.include?("*/") == withASDoc \
    && !line.include?("function set") \
    && !line.include?("toString")
end

relevant_files(ARGV[0]).each do |f|
  previous_line = ""
  api_functions = []
  File.new(f, "r").each do |line|
    if relevant_line(line, previous_line, withASDoc)
      function_name = line.scan(/public function (.+)\(/)[0]
      if function_name == nil
        api_functions.push(line)
      else
        api_functions.push(function_name)
      end
    end
    previous_line = line
  end

  if api_functions.any?
    puts "\n.#{f}"
    api_functions.each do |function_name|
      puts "    -> #{function_name}"
    end
  end
end       
