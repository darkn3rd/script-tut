// testbox: title="manual IEnumerator (GetEnumerator/MoveNext/Current)"
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

class F02Loop
{
    static void Main()
    {
        List<string> items = Directory.GetFileSystemEntries("dirtest")
                                       .Select(Path.GetFileName)
                                       .OrderBy(name => name)
                                       .ToList();

        // step through the enumerator protocol foreach itself desugars to
        using (IEnumerator<string> e = items.GetEnumerator())
        {
            while (e.MoveNext())
            {
                string item = e.Current;
                if (Directory.Exists(Path.Combine("dirtest", item)))
                    Console.WriteLine($"{item} is a directory");
                else
                    Console.WriteLine($"{item} is not a directory");
            }
        }
    }
}
