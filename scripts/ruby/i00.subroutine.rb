#!/usr/bin/env ruby

# create method (subroutine)
def show_date
   time = Time.new
   puts "Today is #{time.strftime("%B %d, %Y")}."
end

# call the method (subroutine)
show_date
