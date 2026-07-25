// testbox: title="do-while (true) with break"
using System;

class F31Loop
{
    static void Main()
    {
        do
        {
            Console.Write("Enter your name (quit to exit): ");
            string answer = Console.ReadLine();

            if (answer == "quit")
                break;

            Console.WriteLine($"Hello {answer}!");
        } while (true);
    }
}
