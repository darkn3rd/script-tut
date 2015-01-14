Option Explicit

' UnZip "C:\test.zip" into the folder "C:\test1"
Extract "C:\test.zip", "C:\test1"

' Extract "C:\test.cab" into the folder "C:\test2"
Extract "C:\test.cab", "C:\test2"

' Copy the contents of folder "C:\test2" to the folder "C:\test3"
Extract "C:\test2", "C:\test3"


Sub Extract( ByVal myZipFile, ByVal myTargetDir )
' Function to extract all files from a compressed "folder"
' (ZIP, CAB, etc.) using the Shell Folders' CopyHere method
' (http://msdn2.microsoft.com/en-us/library/ms723207.aspx).
' All files and folders will be extracted from the ZIP file.
' A progress bar will be displayed, and the user will be
' prompted to confirm file overwrites if necessary.
'
' Note:
' This function can also be used to copy "normal" folders,
' if a progress bar and confirmation dialog(s) are required:
' just use a folder path for the "myZipFile" argument.
'
' Arguments:
' myZipFile    [string]  the fully qualified path of the ZIP file
' myTargetDir  [string]  the fully qualified path of the (existing) destination folder
'
' Based on an article by Gerald Gibson Jr.:
' http://www.codeproject.com/csharp/decompresswinshellapics.asp
'
' Written by Rob van der Woude
' http://www.robvanderwoude.com

    Dim intOptions, objShell, objSource, objTarget

    ' Create the required Shell objects
    Set objShell = CreateObject( "Shell.Application" )

    ' Create a reference to the files and folders in the ZIP file
    Set objSource = objShell.NameSpace( myZipFile ).Items( )

    ' Create a reference to the target folder
    Set objTarget = objShell.NameSpace( myTargetDir )

    ' These are the available CopyHere options, according to MSDN
    ' (http://msdn2.microsoft.com/en-us/library/ms723207.aspx).
    ' On my test systems, however, the options were completely ignored.
    '      4: Do not display a progress dialog box.
    '      8: Give the file a new name in a move, copy, or rename
    '         operation if a file with the target name already exists.
    '     16: Click "Yes to All" in any dialog box that is displayed.
    '     64: Preserve undo information, if possible.
    '    128: Perform the operation on files only if a wildcard file
    '         name (*.*) is specified.
    '    256: Display a progress dialog box but do not show the file
    '         names.
    '    512: Do not confirm the creation of a new directory if the
    '         operation requires one to be created.
    '   1024: Do not display a user interface if an error occurs.
    '   4096: Only operate in the local directory.
    '         Don't operate recursively into subdirectories.
    '   8192: Do not copy connected files as a group.
    '         Only copy the specified files.
    intOptions = 256

    ' UnZIP the files
    objTarget.CopyHere objSource, intOptions

    ' Release the objects
    Set objSource = Nothing
    Set objTarget = Nothing
    Set objShell  = Nothing
End Sub 
