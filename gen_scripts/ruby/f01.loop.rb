#!/usr/bin/env ruby
# collection style loop with each iterator
# NOTE:
# * replaced POSIX subshell dependency: '`ls dirtest`.split.each do |item|' 
entries = Dir.entries("dirtest").reject { |e| e == "." || e == ".." }.sort
entries.each do |item|                    # cycle through directory listing
   if File.directory? "dirtest/#{item}"   # test if path is directory
       puts "#{item} is a directory"
   else
       puts "#{item} is not a directory"
   end
end
