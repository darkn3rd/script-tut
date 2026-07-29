using System;

class E10Branch
{
    static void Main()
    {
        Console.Write("Would you like a toast? [Yes/No]: ");
        string response = Console.ReadLine();

        // C#'s ternary operator
        string message = response == "Yes" ? "That's great!" : "How about a muffin?";

        Console.WriteLine(message);
    }
}
