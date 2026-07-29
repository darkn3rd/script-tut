using System;

class I10Subroutine
{
    // static fields are directly visible and mutable from any static
    //  method in this class - no "global" keyword needed like Python.
    static int pond = 500;
    static int captured = 0;

    static void Fish()
    {
        pond -= 150;
        captured += 150;
    }

    static void Main()
    {
        Console.WriteLine($"We have {pond} in this pond.");

        Fish();
        Console.WriteLine($"Fishing from the main pond... We now have {pond} in the main pond.");

        Fish();
        Console.WriteLine($"Fishing from the main pond... We now have {pond} in the main pond.");

        Fish();
        Console.WriteLine($"Fishing from the main pond... We now have {pond} in the main pond.");

        Console.WriteLine($"We now have a total of {captured} fish captured");
    }
}
