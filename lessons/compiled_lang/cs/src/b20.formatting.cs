using System;

class B20Formatting
{
    static void Main()
    {
        int number = 5;
        char character = 'a';
        string text = "This is a string";

        // Positional format arguments - {0}/{1}/{2} bound to argument
        //  index, C#'s closest analog to printf's ordinal verbs (contrast
        //  with b10's "{number}" interpolation).
        Console.WriteLine(string.Format("Number is {0}.\nCharacter is '{1}'.\nString is \"{2}\".", number, character, text));
    }
}
