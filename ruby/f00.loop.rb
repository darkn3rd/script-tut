#!/usr/bin/ruby
# for/in w/ exec
for item in `ls`.split.each do            # cycle through directory listing
   if File.directory? item                # test if path is directory
       puts "#{item} is a directory."
   else
       puts "#{item} is not a directory."
   end
end