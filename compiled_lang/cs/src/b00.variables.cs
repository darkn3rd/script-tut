using System;

class B00Variables
{
    static void Main()
    {
        int number = 5;
        char character = 'a';
        string text = "This is a string";

        string output = "Number is " + number + ".\n"
            + "Character is '" + character + "'.\n"
            + "String is \"" + text + "\".\n";

        Console.Write(output);
    }
}
