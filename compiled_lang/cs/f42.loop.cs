// testbox: title="do-while (true) with continue"
using System;

class F42Loop
{
    static void Main()
    {
        do
        {
            Console.Write("Enter your name (quit to exit): ");
            string answer = Console.ReadLine();

            if (string.IsNullOrWhiteSpace(answer))
                continue;

            if (answer == "quit")
                break;

            Console.WriteLine($"Hello {answer}!");
        } while (true);
    }
}
