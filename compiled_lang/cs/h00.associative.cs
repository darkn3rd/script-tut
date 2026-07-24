using System;
using System.Collections.Generic;

class H00Associative
{
    static void Main()
    {
        // create empty dictionary
        var ages = new Dictionary<string, int>();
        // insert one element at a time
        ages["bob"] = 34;
        ages["ed"] = 58;
        ages["steve"] = 32;
        ages["ralph"] = 23;
        ages["deb"] = 46;
        ages["kate"] = 19;

        // enumerate and print keys
        Console.WriteLine("Keys (names):  " + string.Join(", ", ages.Keys));
        // enumerate and print values
        Console.WriteLine("Values (ages): " + string.Join(", ", ages.Values));
    }
}
