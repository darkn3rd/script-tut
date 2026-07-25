using System;
using System.Text.RegularExpressions;

class E60Branch
{
    static void Main()
    {
        Console.Write("Input a character: ");
        char keypress = (char)Console.Read();
        string s = keypress.ToString();

        if (Regex.IsMatch(s, "[A-Z]"))
            Console.WriteLine("Uppercase letter");
        else if (Regex.IsMatch(s, "[a-z]"))
            Console.WriteLine("Lowercase letter");
        else if (Regex.IsMatch(s, "[0-9]"))
            Console.WriteLine("Digit");
        else
            Console.WriteLine("Punctuation, whitespace, or other");
    }
}
