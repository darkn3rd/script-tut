#!/usr/bin/env pash
# build/populate hash
$ages = @{"bob"=34; "ed"=58; "steve"=32; "ralph"=23}
# merge new hash into existing hash
$ages += @{"deb"=46; "kate"=19}
# output results
"The ages are: "
foreach ($name in $ages.keys) {   # cycle through whole list
  "  ages[$name]=" + $ages[$name]  # print out each element
}
