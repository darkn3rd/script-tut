using System;

class E20Branch
{
    static void Main()
    {
        Console.Write("Input a number: ");
        int number = int.Parse(Console.ReadLine());

        if (number > 0)
            Console.WriteLine("Number is greater than 0");
        else if (number < 0)
            Console.WriteLine("Number is less than 0");
        else
            Console.WriteLine("Number is 0");
    }
}
