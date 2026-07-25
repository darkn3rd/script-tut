using System;
using System.Collections.Generic;

class H10Associative
{
    static void Main()
    {
        // initialize dictionary with key/value pairs
        var ages = new Dictionary<string, int> {
            { "bob", 34 }, { "ed", 58 }, { "steve", 32 }, { "ralph", 23 }
        };
        // append another set of key/value pairs into dictionary
        var more = new Dictionary<string, int> { { "deb", 46 }, { "kate", 19 } };
        foreach (var pair in more) ages[pair.Key] = pair.Value;

        // iterate through dictionary by keys, print key/value pairs
        Console.WriteLine("The ages are: ");
        foreach (var name in ages.Keys)
        {
            Console.WriteLine($" ages[{name}]={ages[name]}");
        }
    }
}
