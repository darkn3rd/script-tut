#!/usr/bin/env perl
# create the function
sub sort_array {
   return join(", ", sort @_);  # return list
}

# initialize initial array (list)
my @array = ("bob", "ed", "steve", "ralph", "joe", "deb", "kate");
# output current list before calling function
print "Current names are: " . join(", ", @array) . "\n";

# call the function
my $result = sort_array(@array);

# output the result
print "Sorted names are: $result\n";
