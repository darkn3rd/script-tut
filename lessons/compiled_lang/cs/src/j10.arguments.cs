using System;

class J10Arguments
{
    static void Main(string[] args)
    {
        Console.WriteLine("The arguments passed are:");
        for (int i = 0; i < args.Length; i++)
        {
            Console.WriteLine(" item " + (i + 1) + ": " + args[i]);
        }
    }
}
