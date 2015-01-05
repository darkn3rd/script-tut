// Reference the FileSystemObject
var FSO = new ActiveXObject("Scripting.FileSystemObject");
	
// Reference the Text directory
var Folder = FSO.GetFolder(".");

// Reference the File collection of the Text directory
var FileCollection = Folder.Files;

WScript.Echo("JScript Method");

// Display the number of files within the Text directory
WScript.Echo("Number of files found: " + FileCollection.Count);

// Traverse through the FileCollection using the FOR loop
for(var objEnum = new Enumerator(FileCollection); !objEnum.atEnd(); objEnum.moveNext()) {
   strFileName = objEnum.item();
   WScript.Echo(strFileName);
}
