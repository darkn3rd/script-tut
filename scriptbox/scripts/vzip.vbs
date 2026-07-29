Option Explicit

Dim arrResult

arrResult = ZipFolder( "C:\Documents and Settings\MyUserID\Application Data", "C:\MyUserID.zip" )
If arrResult(0) = 0 Then
    If arrResult(1) = 1 Then
        WScript.Echo "Done; 1 empty subfolder was skipped."
    Else
        WScript.Echo "Done; " & arrResult(1) & " empty subfolders were skipped."
    End If
Else
    WScript.Echo "ERROR " & Join( arrResult, vbCrLf )
End If


Function ZipFolder( myFolder, myZipFile )
' This function recursively ZIPs an entire folder into a single ZIP file,
' using only Windows' built-in ("native") objects and methods.
'
' Last Modified:
' October 12, 2008
'
' Arguments:
' myFolder   [string]  the fully qualified path of the folder to be ZIPped
' myZipFile  [string]  the fully qualified path of the target ZIP file
'
' Return Code:
' An array with the error number at index 0, the source at index 1, and
' the description at index 2. If the error number equals 0, all went well
' and at index 1 the number of skipped empty subfolders can be found.
'
' Notes:
' [1] If the specified ZIP file exists, it will be overwritten
'     (NOT APPENDED) without notice!
' [2] Empty subfolders in the specified source folder will be skipped
'     without notice; lower level subfolders WILL be added, whether
'     empty or not.
'
' Based on a VBA script (http://www.rondebruin.nl/windowsxpzip.htm)
' by Ron de Bruin, http://www.rondebruin.nl
'
' (Re)written by Rob van der Woude
' http://www.robvanderwoude.com

    ' Standard housekeeping
    Dim intSkipped, intSrcItems
    Dim objApp, objFolder, objFSO, objItem, objTxt
    Dim strSkipped

    Const ForWriting = 2

    intSkipped = 0

    ' Make sure the path ends with a backslash
    If Right( myFolder, 1 ) <> "\" Then
        myFolder = myFolder & "\"
    End If

    ' Use custom error handling
    On Error Resume Next

    ' Create an empty ZIP file
    Set objFSO = CreateObject( "Scripting.FileSystemObject" )
    Set objTxt = objFSO.OpenTextFile( myZipFile, ForWriting, True )
    objTxt.Write "PK" & Chr(5) & Chr(6) & String( 18, Chr(0) )
    objTxt.Close
    Set objTxt = Nothing

    ' Abort on errors
    If Err Then
        ZipFolder = Array( Err.Number, Err.Source, Err.Description )
        Err.Clear
        On Error Goto 0
        Exit Function
    End If
    
    ' Create a Shell object
    Set objApp = CreateObject( "Shell.Application" )

    ' Copy the files to the compressed folder
    For Each objItem in objApp.NameSpace( myFolder ).Items
        If objItem.IsFolder Then
            ' Check if the subfolder is empty, and if
            ' so, skip it to prevent an error message
            Set objFolder = objFSO.GetFolder( objItem.Path )
            If objFolder.Files.Count + objFolder.SubFolders.Count = 0 Then
                intSkipped = intSkipped + 1
            Else
                objApp.NameSpace( myZipFile ).CopyHere objItem
            End If
        Else
            objApp.NameSpace( myZipFile ).CopyHere objItem
        End If
    Next

    Set objFolder = Nothing
    Set objFSO    = Nothing

    ' Abort on errors
    If Err Then
        ZipFolder = Array( Err.Number, Err.Source, Err.Description )
        Set objApp = Nothing
        Err.Clear
        On Error Goto 0
        Exit Function
    End If

    ' Keep script waiting until compression is done
    intSrcItems = objApp.NameSpace( myFolder  ).Items.Count
    Do Until objApp.NameSpace( myZipFile ).Items.Count + intSkipped = intSrcItems
        WScript.Sleep 200
    Loop
    Set objApp = Nothing

    ' Abort on errors
    If Err Then
        ZipFolder = Array( Err.Number, Err.Source, Err.Description )
        Err.Clear
        On Error Goto 0
        Exit Function
    End If

    ' Restore default error handling
    On Error Goto 0

    ' Return message if empty subfolders were skipped
    If intSkipped = 0 Then
        strSkipped = ""
    Else
        strSkipped = "skipped empty subfolders"
    End If

    ' Return code 0 (no error occurred)
    ZipFolder = Array( 0, intSkipped, strSkipped )
End Function
