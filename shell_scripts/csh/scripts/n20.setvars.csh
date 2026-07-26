#!/usr/bin/env tcsh
# tcsh has no arrays of pairs and no functions - each drink's quantity
#  is tracked as a separate plain variable, matched by hand against
#  each "Key:Qty" argument, and the final list is built by referencing
#  them in a hardcoded alphabetical-by-key order rather than sorting
#  dynamically.
if ($#argv == 0) then
  # tcsh has no $RANDOM at all (unlike bash/ksh) - $$ (this process's
  #  own PID) stands in as a simple varying seed instead, offset
  #  differently per drink so they don't all land on the same value.
  @ q_coffee = ( $$ + 0 ) % 3
  @ q_espresso = ( $$ + 1 ) % 3
  @ q_latte = ( $$ + 2 ) % 3
  @ q_machiato = ( $$ + 3 ) % 3
  @ q_capucino = ( $$ + 4 ) % 3
  @ q_mocha = ( $$ + 5 ) % 3
  @ q_tea = ( $$ + 6 ) % 3
else
  set q_coffee = 0
  set q_espresso = 0
  set q_latte = 0
  set q_machiato = 0
  set q_capucino = 0
  set q_mocha = 0
  set q_tea = 0
  foreach pair ($argv)
    set key = `echo "$pair" | cut -d: -f1`
    set qty = `echo "$pair" | cut -d: -f2`
    switch ("$key")
      case "Coffee":
        set q_coffee = $qty
        breaksw
      case "Espresso":
        set q_espresso = $qty
        breaksw
      case "Latte":
        set q_latte = $qty
        breaksw
      case "Machiato":
        set q_machiato = $qty
        breaksw
      case "Capucino":
        set q_capucino = $qty
        breaksw
      case "Mocha":
        set q_mocha = $qty
        breaksw
      case "Tea":
        set q_tea = $qty
        breaksw
    endsw
  end
endif

set order = ""
foreach entry ("Capucino:$q_capucino" "Coffee:$q_coffee" "Espresso:$q_espresso" "Latte:$q_latte" "Machiato:$q_machiato" "Mocha:$q_mocha" "Tea:$q_tea")
  set qty = `echo "$entry" | cut -d: -f2`
  if ("$qty" != "0") then
    if ("$order" == "") then
      set order = "$entry"
    else
      set order = "$order,$entry"
    endif
  endif
end

setenv MY_ORDERS "$order"

# Dump the whole environment (plain "KEY=value" lines) to a well-known
#  file for an external observer to inspect while this script is
#  paused below - deleted again once that observer is done and this
#  script is about to exit. Explicit /usr/bin/env, not bare "env": a
#  shell's tracked-alias cache for bare command names can latch onto a
#  *different* env.exe already on PATH (e.g. Git for Windows bundles
#  its own) whose own runtime doesn't see this process's
#  freshly-exported variables - confirmed empirically while debugging
#  this exact lesson under ksh.
/usr/bin/env > dump_env.out

echo "MY_ORDERS set, Hit Return to continue"
set _ = $<

rm -f dump_env.out
