// testbox: title="do-while loop"
using System;

class F12Loop
{
    static void Main()
    {
        int count = 10;
        do
        {
            Console.WriteLine($"Count is {count}");
            count--;
        } while (count > 0);
    }
}
