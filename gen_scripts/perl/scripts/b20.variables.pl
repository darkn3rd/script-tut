#!/usr/bin/env perl -w
# declare variables
my $num = 5;
my $chr = 'a';
my $str = "This is a string";

# use printf-style formatting instead of concatenation/interpolation
printf("Number is %d.\n", $num);
printf("Character is '%s'.\n", $chr);
printf("String is \"%s\".\n", $str);
