#!/usr/bin/env ruby
# testbox: title="Dir.entries with for..in collection"
# collection loop from output of directory listing, without a subshell -
# see f00.loop.rb for the subshell (`ls`) version of this same lesson
entries = Dir.entries("dirtest").reject { |e| e == "." || e == ".." }.sort
for item in entries                       # cycle through directory listing
   if File.directory? "dirtest/#{item}"  # test if path is directory
       puts "#{item} is a directory"
   else
       puts "#{item} is not a directory"
   end
end
