#!/usr/bin/ruby

# create function (subroutine)
def show_date
   time = Time.new
  
   puts "Today is #{time.strftime("%b %d, %Y")}."
end

# call the function (subroutine)
show_date