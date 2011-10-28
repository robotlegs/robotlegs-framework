
desc 'Prepare the AllTests class to test a specific package'
task :testpackage, :packageName do |t, args|
  tempFile = File.new("test/temp.as", "w");
  allTestsFile = File.open("test/AllTests.as", "r");
  allTestsFile.each do |line|
     line = line.gsub('//','')
     if((line.include?('addTest'))||((line.include?('import'))&&(!line.include?('asunit'))))
       if !(line.include?(args.packageName))
         line = '//' + line
       end
     end
     tempFile.write(line)  
  end
  tempFile.close
  allTestsFile.close
  File.delete("test/AllTests.as")
  File.rename("test/temp.as", "test/AllTests.as")
  
  Rake::Task[ "test" ].invoke
  
end 

desc 'Prepare the AllTests class to test a specific package'
task :testallexcept, :packageName do |t, args|
  tempFile = File.new("test/temp.as", "w");
  allTestsFile = File.open("test/AllTests.as", "r");
  allTestsFile.each do |line|
     line = line.gsub('//','')
     if(line.include?('addTest'))
       if (line.include?(args.packageName))
         line = '//' + line
       end
     end
     tempFile.write(line)  
  end
  tempFile.close
  allTestsFile.close
  File.delete("test/AllTests.as")
  File.rename("test/temp.as", "test/AllTests.as")
  
  Rake::Task[ "test" ].invoke
  
end

desc 'Set all tests active in the AllTests.as package'
task :testall do
  tempFile = File.new("test/temp.as", "w");
  allTestsFile = File.open("test/AllTests.as", "r");
  allTestsFile.each do |line|
     line = line.gsub('//','')
     tempFile.write(line)  
  end
  tempFile.close
  allTestsFile.close
  File.delete("test/AllTests.as")
  File.rename("test/temp.as", "test/AllTests.as")
  
  Rake::Task[ "test" ].invoke
  
end