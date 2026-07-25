// testbox: title="for loop as conditional loop"
using System;

class F21Loop
{
    static void Main()
    {
        // the for statement's own increment clause is left empty - answer
        //  is reassigned in the body instead, so the loop's only real job
        //  here is testing the condition before each pass
        for (string answer = ""; answer != "quit"; )
        {
            Console.Write("Enter your name (quit to Exit): ");
            answer = Console.ReadLine();

            if (answer != "quit")
                Console.WriteLine($"Hello {answer}!");
        }
    }
}
