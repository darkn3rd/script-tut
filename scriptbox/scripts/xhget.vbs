'strLink = "http://download.windowsupdate.com/microsoftupdate/v6/wsusscan/wsusscn2.cab"
strLink = "http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe"

' Get file name from URL.
' http://download.windowsupdate.com/microsoftupdate/v6/wsusscan/wsusscn2.cab -> wsusscn2.cab
strSaveName = Mid(strLink, InStrRev(strLink,"/") + 1, Len(strLink))
strSaveTo = "C:\" & strSaveName

WScript.Echo "HTTPDownload"
WScript.Echo "-------------"
WScript.Echo "Download: " & strLink
WScript.Echo "Save to:  " & strSaveTo

' Create an HTTP object
Set objHTTP = CreateObject("MSXML2.XMLHTTP")

' Download the specified URL
'xmlhttp.Open "GET", strURL, false, "User", "Password"
objHTTP.open "GET", strLink, False
objHTTP.send

Set objFSO = CreateObject("Scripting.FileSystemObject")
If objFSO.FileExists(strSaveTo) Then
  objFSO.DeleteFile(strSaveTo)
End If

If objHTTP.Status = 200 Then
  Dim objStream
  Set objStream = CreateObject("ADODB.Stream")
  With objStream
    .Type = 1 'adTypeBinary
    .Open
    .Write objHTTP.responseBody
    .SaveToFile strSaveTo
    .Close
  End With
  set objStream = Nothing
End If

If objFSO.FileExists(strSaveTo) Then
  WScript.Echo "Download `" & strSaveName & "` completed successfuly."
End If
