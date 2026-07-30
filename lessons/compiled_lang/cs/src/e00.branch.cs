using System;

class E00Branch
{
    static void Main()
    {
        Console.Write("Would you like a toast? [Yes/No]: ");
        string response = Console.ReadLine();

        string message;
        if (response == "Yes")
            message = "That's great!";
        else
            message = "How about a muffin?";

        Console.WriteLine(message);
    }
}
