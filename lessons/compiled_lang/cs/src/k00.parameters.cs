using System;

class K00Parameters
{
    static void Celsius(double fahrenheit)
    {
        double temperature = (fahrenheit - 32.0) * 5 / 9;
        Console.WriteLine("The Celsius temperature is " + temperature.ToString("F1") + " degrees.");
    }

    static void Main()
    {
        double temperature = 73;
        Celsius(temperature);
    }
}
