#!/usr/bin/ruby
# each iterator w/ sub-process
`ls`.split.each do |item|                 # cycle thorugh directory listing
   if File.directory? item                # test if path is directory
       puts "#{item} is a directory."
   else
       puts "#{item} is not a directory."
   end
end