using System;

class J20Arguments
{
    static void Main(string[] args)
    {
        Console.WriteLine("The arguments passed are (reverse order):");
        for (int i = args.Length - 1; i >= 0; i--)
        {
            Console.WriteLine(" item " + (i + 1) + ": " + args[i]);
        }
    }
}
