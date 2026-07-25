// testbox: title="for (;;) with break"
using System;

class F32Loop
{
    static void Main()
    {
        for (;;)
        {
            Console.Write("Enter your name (quit to exit): ");
            string answer = Console.ReadLine();

            if (answer == "quit")
                break;

            Console.WriteLine($"Hello {answer}!");
        }
    }
}
