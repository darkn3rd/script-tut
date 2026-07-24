// testbox: title="while loop"
using System;

class F20Loop
{
    static void Main()
    {
        string answer = "";
        while (answer != "quit")
        {
            Console.Write("Enter your name (quit to Exit): ");
            answer = Console.ReadLine();

            if (answer != "quit")
                Console.WriteLine($"Hello {answer}!");
        }
    }
}
