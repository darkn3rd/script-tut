using System;

class M20Function
{
    static string[] SortArray(string[] array)
    {
        string[] result = (string[])array.Clone();
        Array.Sort(result);
        return result;
    }

    static void Main()
    {
        string[] array = { "bob", "ed", "steve", "ralph", "joe", "deb", "kate" };
        Console.WriteLine("Current names are: " + string.Join(", ", array));

        string[] result = SortArray(array);
        Console.WriteLine("Sorted names are: " + string.Join(", ", result));
    }
}
