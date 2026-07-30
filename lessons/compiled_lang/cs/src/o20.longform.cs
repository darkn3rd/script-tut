using System;
using System.Collections.Generic;

class O20Longform
{
    static void Usage(System.IO.TextWriter outp, string scriptName)
    {
        outp.WriteLine();
        outp.WriteLine("Usage: " + scriptName + " [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]");
        outp.WriteLine();
        outp.WriteLine("  --coffee,    -c N  Coffee");
        outp.WriteLine("  --espresso,  -e N  Espresso");
        outp.WriteLine("  --latte,     -l N  Latte");
        outp.WriteLine("  --macchiato, -k N  Machiato");
        outp.WriteLine("  --capucino,  -p N  Capucino");
        outp.WriteLine("  --mocha,     -m N  Mocha");
        outp.WriteLine("  --tea,       -t N  Tea");
        outp.WriteLine("  --help,      -h    Display this help message");
        outp.WriteLine("  -?                 Display this help message");
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

        List<string> names = new List<string>();
        List<string> counts = new List<string>();

        int i = 0;
        while (i < args.Length)
        {
            switch (args[i])
            {
                case "--coffee":
                case "-c":
                    names.Add("coffee");
                    counts.Add(args[i + 1]);
                    i += 2;
                    break;
                case "--espresso":
                case "-e":
                    names.Add("espresso");
                    counts.Add(args[i + 1]);
                    i += 2;
                    break;
                case "--latte":
                case "-l":
                    names.Add("latte");
                    counts.Add(args[i + 1]);
                    i += 2;
                    break;
                case "--macchiato":
                case "-k":
                    names.Add("macchiato");
                    counts.Add(args[i + 1]);
                    i += 2;
                    break;
                case "--capucino":
                case "-p":
                    names.Add("capucino");
                    counts.Add(args[i + 1]);
                    i += 2;
                    break;
                case "--mocha":
                case "-m":
                    names.Add("mocha");
                    counts.Add(args[i + 1]);
                    i += 2;
                    break;
                case "--tea":
                case "-t":
                    names.Add("tea");
                    counts.Add(args[i + 1]);
                    i += 2;
                    break;
                case "--help":
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

        if (names.Count == 0)
        {
            Usage(Console.Error, scriptName);
            Environment.Exit(1);
            return;
        }

        Console.WriteLine();
        Console.WriteLine("You ordered: ");
        for (int j = 0; j < names.Count; j++)
        {
            int n = int.Parse(counts[j]);
            string label = names[j];
            if (n != 1)
            {
                label += "s";
            }
            Console.WriteLine("* " + counts[j] + " " + label);
        }
    }
}
