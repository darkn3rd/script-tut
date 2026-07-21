#!/usr/bin/env awk -f
BEGIN {
  # string with key:value pairs
  some_ages = "bob:34 ed:58 steve:32 ralph:23"
  # create 1st associative array
  make_array(some_ages, ages)

  # second key:value string
  more_ages = "deb:46 kate:19"
  # create 2nd associative array
  make_array(more_ages, ages_two)

  # merge two associative arrays
  merge(ages, ages_two)

  # iterate through associative array in insertion order, print key/value
  #  pairs (awk's "for (key in array)" iteration order is unspecified, so
  #  key_order, built up in make_array, is used instead)
  print "The ages are: "
  for (i = 1; i <= key_count; i++) {
    name = key_order[i]
    printf " ages[%s]=%s\n", name, ages[name]
  }
}

# ==================== HELPER FUNCTIONS ==================== #
# Helper Functions as Awk has no method to create associative
#   arrays in one line or merge two associative arrays

# **************************************
# make_array (scalar, array) - populates array given a string scalar.
#   Also appends each key to the global key_order/key_count so callers
#   can enumerate in insertion order later.
# **************************************
function make_array(strIn, arrOut,    couplets, count, i, pair, name, age)
{
  split(strIn, couplets)              # craft new array from key:value pairs

  count = 0
  for (i in couplets) count++         # POSIX awk has no length(array)

  # Note: split() always starts array indices at 1, so an explicit
  #  numeric loop (rather than "for (i in couplets)") walks it in the
  #  original key:value order
  for (i = 1; i <= count; i++) {
    split(couplets[i], pair, ":")     # create mini-array of key and value

    # not the most efficient, but more illustrative
    name = pair[1]                    # save name
    age  = pair[2]                    # save age

    # build the output associative array
    arrOut[name] = age
    key_order[++key_count] = name     # remember insertion order (global)
  }
}

# **************************************
# merge (array, array) - merges two arrays; left-most array is output
#   Warning: does not verify uniqueness of key index
# **************************************
function merge(arrIn, arrOut)
{
  # put items from arrOut into arrIn
  #  Note: arrIn dynamically resized to accomodate
  for (key in arrOut) arrIn[key] = arrOut[key]
}
