// testbox: title="for (;;) with continue"
using System;

class F41Loop
{
    static void Main()
    {
        for (;;)
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
