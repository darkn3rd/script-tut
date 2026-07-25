// testbox: title="foreach over Directory.GetFileSystemEntries()"
using System;
using System.IO;
using System.Linq;

class F00Loop
{
    static void Main()
    {
        // Directory.GetFileSystemEntries() order isn't guaranteed by the
        //  filesystem, so sort by name first
        foreach (string item in Directory.GetFileSystemEntries("dirtest")
                                          .Select(Path.GetFileName)
                                          .OrderBy(name => name))
        {
            if (Directory.Exists(Path.Combine("dirtest", item)))
                Console.WriteLine($"{item} is a directory");
            else
                Console.WriteLine($"{item} is not a directory");
        }
    }
}
