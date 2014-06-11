#!/bin/awk -f
BEGIN {
  
  split("bob 34 ed 58 steve 32 ralph 23 deb 46 kate 19", a)
  for (i = 1; i < 4; i += 2) {b[a[i]] = a[i+1];}


  printf "Keys  (names): "
  for (name in a) {
    print " " name "=" a[name]
  }


}
