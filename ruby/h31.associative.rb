@ages = {bob: :34, ed: :58, steve: :32, ralph: :23}

#ages = ages.merge("deb"=> 46, "kate"=> 19)
# iterate through hash by key/value, print key/value pairs
puts "The ages are: "
ages.each { |name,age| puts " ages[#{name}]=#{age}"}
