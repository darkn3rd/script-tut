wscript.stdout.write "Input a number: "
number = cint(wscript.stdin.readline)

if number > 0 then
  wscript.echo "Number is greater than 0"
ElseIf Number < 0 then
  wscript.echo "Number is less than 0"
Else
  wscript.echo "Number is 0"
end if
