#!/usr/bin/env ruby
# collection loop from output of directory listing
# NOTE:
# * replaced POSIX subshell dependency: 'for item in `ls dirtest`.split.each do'
entries = Dir.entries("dirtest").reject { |e| e == "." || e == ".." }.sort
for item in entries                       # cycle through directory listing
   if File.directory? "dirtest/#{item}"  # test if path is directory
       puts "#{item} is a directory"
   else
       puts "#{item} is not a directory"
   end
end
