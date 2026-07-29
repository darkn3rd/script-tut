using System;

class G10Array
{
    static void Main()
    {
        string[] nicknames = { "bob", "ed", "steve", "ralph", "joe", "deb", "kate" };

        Console.WriteLine("The names are: ");
        foreach (string name in nicknames)
        {
            Console.WriteLine("  " + name);
        }
    }
}
