using System;

class I00Subroutine
{
    static void ShowDate()
    {
        Console.WriteLine("Today is " + DateTime.Now.ToString("MMMM d, yyyy") + ".");
    }

    static void Main()
    {
        ShowDate();
    }
}
