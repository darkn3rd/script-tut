#!/usr/bin/env ruby
# testbox: requires=posix
# testbox: title="subshell with for..in collection"
# collection loop from output of subshell
for item in `ls dirtest`.split.each do   # cycle through directory listing
   if File.directory? "dirtest/#{item}"  # test if path is directory
       puts "#{item} is a directory"
   else
       puts "#{item} is not a directory"
   end
end
