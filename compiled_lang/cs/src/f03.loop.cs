// testbox: title="indexed for loop over List<T>"
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class F03Loop
{
    static void Main()
    {
        List<string> items = Directory.GetFileSystemEntries("dirtest")
                                       .Select(Path.GetFileName)
                                       .OrderBy(name => name)
                                       .ToList();

        for (int i = 0; i < items.Count; i++)
        {
            string item = items[i];
            if (Directory.Exists(Path.Combine("dirtest", item)))
                Console.WriteLine($"{item} is a directory");
            else
                Console.WriteLine($"{item} is not a directory");
        }
    }
}
