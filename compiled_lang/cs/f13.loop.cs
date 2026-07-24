// testbox: title="Enumerable.Range().Reverse() with foreach"
using System;
using System.Linq;

class F13Loop
{
    static void Main()
    {
        foreach (int count in Enumerable.Range(1, 10).Reverse())
            Console.WriteLine($"Count is {count}");
    }
}
