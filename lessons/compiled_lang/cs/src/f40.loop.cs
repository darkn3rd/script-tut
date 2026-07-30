// testbox: title="while (true) with continue"
using System;

class F40Loop
{
    static void Main()
    {
        while (true)
        {
            Console.Write("Enter your name (quit to exit): ");
            string answer = Console.ReadLine();

            if (string.IsNullOrWhiteSpace(answer))
                continue;

            if (answer == "quit")
                break;

            Console.WriteLine($"Hello {answer}!");
        }
    }
}
