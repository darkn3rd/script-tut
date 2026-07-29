using System;

class G00Array
{
    static void Main()
    {
        // populate array one item at a time
        string[] nicknames = new string[7];
        nicknames[0] = "bob";
        nicknames[1] = "ed";
        nicknames[2] = "steve";
        nicknames[3] = "ralph";
        nicknames[4] = "joe";
        nicknames[5] = "deb";
        nicknames[6] = "kate";

        Console.WriteLine("The total nicknames are: " + nicknames.Length);
        Console.WriteLine("The nicknames are: " + string.Join(", ", nicknames));
    }
}
