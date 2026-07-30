using System;

class E50Branch
{
    static void Main()
    {
        Console.Write("Input a character: ");
        char keypress = (char)Console.Read();

        // pattern-matching switch (C# 7+) - `when` guards let each case
        //  test a predicate instead of just an equality constant
        switch (keypress)
        {
            case char c when char.IsUpper(c):
                Console.WriteLine("Uppercase letter");
                break;
            case char c when char.IsLower(c):
                Console.WriteLine("Lowercase letter");
                break;
            case char c when char.IsDigit(c):
                Console.WriteLine("Digit");
                break;
            default:
                Console.WriteLine("Punctuation, whitespace, or other");
                break;
        }
    }
}
