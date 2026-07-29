using System;

class M00Function
{
    static int AddNums(params int[] numbers)
    {
        int sum = 0;
        foreach (int num in numbers)
        {
            sum += num;
        }
        return sum;
    }

    static void Main()
    {
        Console.WriteLine("The numbers to be added are 5, 2, 4, 3, 6.");

        int result = AddNums(5, 2, 4, 3, 6);
        Console.WriteLine("The result of their summation is: " + result + ".");
    }
}
