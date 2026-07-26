using System;

class G20Array
{
    static void Main()
    {
        string[] nicknames = { "bob", "ed", "steve", "ralph", "joe", "deb", "kate" };

        Console.WriteLine("The names are: ");
        for (int i = 0; i < nicknames.Length; i++)
        {
            Console.WriteLine(" nicknames[" + i + "]=" + nicknames[i]);
        }
    }
}
