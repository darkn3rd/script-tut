using System;

class D10Input
{
    static void Main()
    {
        Console.Write("Input a character: ");
        // Console.In.Read() reads exactly one character's code from
        //  stdin as an int - unlike Console.ReadKey(), which requires a
        //  real interactive console and fails/hangs on redirected stdin.
        char character = (char)Console.In.Read();
        Console.WriteLine($"You entered: >>|{character}|<<.");
    }
}
