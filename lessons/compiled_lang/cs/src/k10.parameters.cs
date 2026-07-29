using System;

class K10Parameters
{
    static void AddNums(params int[] numbers)
    {
        int sum = 0;
        foreach (int num in numbers)
        {
            sum += num;
        }
        Console.WriteLine("The summation is: " + sum + ".");
    }

    static void Main()
    {
        Console.WriteLine("Sending: 5, 2, 4, 3, 6");
        AddNums(5, 2, 4, 3, 6);
    }
}
