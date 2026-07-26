using System;

class J00Arguments
{
    static void Main(string[] args)
    {
        string scriptName = Environment.GetCommandLineArgs()[0];

        if (args.Length != 2)
        {
            Console.Error.WriteLine();
            Console.Error.WriteLine("You need to enter two numbers:");
            Console.Error.WriteLine();
            Console.Error.WriteLine("   Usage: " + scriptName + " [num1] [num2]");
            Console.Error.WriteLine();
        }
        else
        {
            int sum = int.Parse(args[0]) + int.Parse(args[1]);
            Console.WriteLine("The sum of " + args[0] + " and " + args[1] + " is: " + sum + ".");
        }
    }
}
