// testbox: title="List<T>.ForEach() with lambda"
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class F01Loop
{
    static void Main()
    {
        List<string> items = Directory.GetFileSystemEntries("dirtest")
                                       .Select(Path.GetFileName)
                                       .OrderBy(name => name)
                                       .ToList();

        items.ForEach(item =>
        {
            if (Directory.Exists(Path.Combine("dirtest", item)))
                Console.WriteLine($"{item} is a directory");
            else
                Console.WriteLine($"{item} is not a directory");
        });
    }
}
