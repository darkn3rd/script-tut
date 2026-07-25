// testbox: title="while (true) with break"
using System;

class F30Loop
{
    static void Main()
    {
        while (true)
        {
            Console.Write("Enter your name (quit to exit): ");
            string answer = Console.ReadLine();

            if (answer == "quit")
                break;

            Console.WriteLine($"Hello {answer}!");
        }
    }
}
