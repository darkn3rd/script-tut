#!/usr/bin/env ruby
# collection loop from output of subshell
for item in `ls`.split.each do            # cycle through directory listing
   if File.directory? item                # test if path is directory
       puts "#{item} is a directory."
   else
       puts "#{item} is not a directory."
   end
end