#!/usr/bin/env ruby
# collection style loop with each iterator
`ls dirtest`.split.each do |item|         # cycle thorugh directory listing
   if File.directory? "dirtest/#{item}"   # test if path is directory
       puts "#{item} is a directory"
   else
       puts "#{item} is not a directory"
   end
end
