' create subroutine
Sub celsius(fahrenheit)
  temperature = (fahrenheit - 32) * 5 / 9   ' calculate to internatioanl temp
  temperature = FormatNumber(temperature,1) ' lower degree of significance

  ' output results
  WScript.echo "The Celsius temperature is " & temperature & " degrees."
End Sub

temperature = 73 
' call subroutine
celsius temperature
