using System;

class N10Getpath
{
    static void Main()
    {
        string[] dirs = Environment.GetEnvironmentVariable("PATH").Split(System.IO.Path.PathSeparator);
        foreach (string dir in dirs)
        {
            Console.WriteLine(dir);
        }
    }
}
