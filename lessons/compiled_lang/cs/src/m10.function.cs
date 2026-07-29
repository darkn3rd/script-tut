using System;

class M10Function
{
    static string Capitalize(string s)
    {
        return s.ToUpper();
    }

    static void Main()
    {
        string s = "ibm";
        Console.WriteLine("The current string is: \"" + s + "\".");

        string result = Capitalize(s);
        Console.WriteLine("The capitalized string is: \"" + result + "\".");
    }
}
