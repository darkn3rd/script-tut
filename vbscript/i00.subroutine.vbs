' create subroutine
Sub show_date()
  dateStr = FormatDateTime(Date,vbLongDate) ' fetch full date
  dateStr = Split(dateStr,", ", 2)(1)       ' remove day of week

  WScript.echo "Today is " & dateStr & "."  ' output result
End Sub

' call the subroutine 
show_date