using System;
using System.Collections.Generic;

class O10Options
{
    static void Usage(System.IO.TextWriter outp, string scriptName)
    {
        outp.WriteLine();
        outp.WriteLine("Usage: " + scriptName + " [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]");
        outp.WriteLine();
        outp.WriteLine("  -c  Coffee");
        outp.WriteLine("  -e  Espresso");
        outp.WriteLine("  -l  Latte");
        outp.WriteLine("  -k  Machiato");
        outp.WriteLine("  -p  Capucino");
        outp.WriteLine("  -m  Mocha");
        outp.WriteLine("  -t  Tea");
        outp.WriteLine("  -h  Display this help message");
        outp.WriteLine("  -?  Display this help message");
        outp.WriteLine();
    }

    static void Main(string[] args)
    {
        string scriptName = Environment.GetCommandLineArgs()[0];

        if (args.Length == 0)
        {
            Usage(Console.Error, scriptName);
            Environment.Exit(1);
            return;
        }

        List<string> orders = new List<string>();

        foreach (string arg in args)
        {
            switch (arg)
            {
                case "-c":
                    orders.Add("coffee");
                    break;
                case "-e":
                    orders.Add("espresso");
                    break;
                case "-l":
                    orders.Add("latte");
                    break;
                case "-k":
                    orders.Add("macchiato");
                    break;
                case "-p":
                    orders.Add("capucino");
                    break;
                case "-m":
                    orders.Add("mocha");
                    break;
                case "-t":
                    orders.Add("tea");
                    break;
                case "-h":
                case "-?":
                    Usage(Console.Out, scriptName);
                    Environment.Exit(0);
                    return;
                default:
                    Usage(Console.Error, scriptName);
                    Environment.Exit(1);
                    return;
            }
        }

        Console.WriteLine();
        Console.WriteLine("You ordered: ");
        foreach (string drink in orders)
        {
            Console.WriteLine("* " + drink);
        }
    }
}
