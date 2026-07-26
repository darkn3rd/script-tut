using System;

class L00Exit
{
    const int EX_USAGE = 64;
    const int EX_OK = 0;

    static void UsageMessage(string scriptName)
    {
        Console.Error.WriteLine();
        Console.Error.WriteLine("You need to enter one or more numbers:");
        Console.Error.WriteLine();
        Console.Error.WriteLine("   Usage: " + scriptName + " [num1] [num2] [num3]...");
        Console.Error.WriteLine();
        Environment.Exit(EX_USAGE);
    }

    static void AddNums(string[] numbers)
    {
        int sum = 0;
        foreach (string num in numbers)
        {
            sum += int.Parse(num);
        }
        Console.WriteLine("The summation is: " + sum + ".");
        Environment.Exit(EX_OK);
    }

    static void Main(string[] args)
    {
        string scriptName = Environment.GetCommandLineArgs()[0];

        if (args.Length < 1)
        {
            UsageMessage(scriptName);
        }
        else
        {
            AddNums(args);
        }
    }
}
