#!/usr/bin/env ruby
# testbox: requires=posix
# testbox: title="subshell with each iterator collection"
# collection style loop with each iterator, from output of subshell
`ls dirtest`.split.each do |item|         # cycle thorugh directory listing
   if File.directory? "dirtest/#{item}"   # test if path is directory
       puts "#{item} is a directory"
   else
       puts "#{item} is not a directory"
   end
end
