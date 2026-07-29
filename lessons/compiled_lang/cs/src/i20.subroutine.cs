using System;

class I20Subroutine
{
    static int pond = 500; // never mutated - Fish() only touches its own local copy
    static int captured = 0;

    static void Fish()
    {
        int pond = 500; // shadows the static field for the rest of this method
        pond -= 150;
        captured += 150;
    }

    static void Main()
    {
        Console.WriteLine($"We have {pond} in this pond.");

        Fish();
        Console.WriteLine($"Fishing from a local pond... We now have {pond} in the main pond.");

        Fish();
        Console.WriteLine($"Fishing from a local pond... We now have {pond} in the main pond.");

        Fish();
        Console.WriteLine($"Fishing from a local pond... We now have {pond} in the main pond.");

        Console.WriteLine($"We now have a total of {captured} fish captured");
    }
}
