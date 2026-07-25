using System;

class E30Branch
{
    static void Main()
    {
        Console.Write(
            "Select an item from the menu.\n\n" +
            "  1 - Coffee\n" +
            "  2 - Espresso\n" +
            "  3 - Latte\n" +
            "  4 - Machiato\n" +
            "  5 - Capucino\n" +
            "  6 - Mocha\n" +
            "  7 - Tea\n\n" +
            "Make your selection: ");

        int selection = Console.Read() - '0';

        if (selection == 1)
            Console.WriteLine("You selected a Coffee");
        else if (selection == 2)
            Console.WriteLine("You selected an Espresso");
        else if (selection == 3)
            Console.WriteLine("You selected a Latte");
        else if (selection == 4)
            Console.WriteLine("You selected a Machiato");
        else if (selection == 5)
            Console.WriteLine("You selected a Capucino");
        else if (selection == 6)
            Console.WriteLine("You selected a Mocha");
        else if (selection == 7)
            Console.WriteLine("You selected a Tea");
        else
            Console.WriteLine("You have not entered a valid selection");
    }
}
