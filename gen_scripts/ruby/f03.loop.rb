#!/usr/bin/env ruby
# testbox: title="Dir.entries with each iterator collection"
# collection style loop with each iterator, without a subshell - see
# f02.loop.rb for the subshell (`ls`) version of this same lesson
entries = Dir.entries("dirtest").reject { |e| e == "." || e == ".." }.sort
entries.each do |item|                    # cycle through directory listing
   if File.directory? "dirtest/#{item}"   # test if path is directory
       puts "#{item} is a directory"
   else
       puts "#{item} is not a directory"
   end
end
