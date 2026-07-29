using System;

class O00Flags
{
    static void Usage(System.IO.TextWriter outp, string scriptName)
    {
        outp.WriteLine();
        outp.WriteLine("Usage: " + scriptName + " [-c|-e|-l|-k|-p|-m|-t] [-h|-?]");
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

        switch (args[0])
        {
            case "-c":
                Console.WriteLine("You ordered a Coffee.");
                break;
            case "-e":
                Console.WriteLine("You ordered an Espresso.");
                break;
            case "-l":
                Console.WriteLine("You ordered a Latte.");
                break;
            case "-k":
                Console.WriteLine("You ordered a Machiato.");
                break;
            case "-p":
                Console.WriteLine("You ordered a Capucino.");
                break;
            case "-m":
                Console.WriteLine("You ordered a Mocha.");
                break;
            case "-t":
                Console.WriteLine("You ordered a Tea.");
                break;
            case "-h":
            case "-?":
                Usage(Console.Out, scriptName);
                break;
            default:
                Usage(Console.Error, scriptName);
                Environment.Exit(1);
                break;
        }
    }
}
