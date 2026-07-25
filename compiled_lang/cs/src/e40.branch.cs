using System;

class E40Branch
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

        switch (selection)
        {
            case 1:
                Console.WriteLine("You selected a Coffee");
                break;
            case 2:
                Console.WriteLine("You selected an Espresso");
                break;
            case 3:
                Console.WriteLine("You selected a Latte");
                break;
            case 4:
                Console.WriteLine("You selected a Machiato");
                break;
            case 5:
                Console.WriteLine("You selected a Capucino");
                break;
            case 6:
                Console.WriteLine("You selected a Mocha");
                break;
            case 7:
                Console.WriteLine("You selected a Tea");
                break;
            default:
                Console.WriteLine("You have not entered a valid selection");
                break;
        }
    }
}
