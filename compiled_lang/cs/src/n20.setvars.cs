using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

class N20Setvars
{
    static void Main(string[] args)
    {
        // SortedDictionary, not a plain Dictionary - it keeps keys in
        //  sorted order for free, which is exactly the order the joined
        //  MY_ORDERS value needs.
        SortedDictionary<string, int> drinks = new SortedDictionary<string, int>();
        foreach (string key in new[] { "Capucino", "Coffee", "Espresso", "Latte", "Machiato", "Mocha", "Tea" })
        {
            drinks[key] = 0;
        }

        if (args.Length == 0)
        {
            Random rand = new Random();
            List<string> keys = new List<string>(drinks.Keys);
            foreach (string key in keys)
            {
                drinks[key] = rand.Next(3);
            }
        }
        else
        {
            foreach (string pair in args)
            {
                string[] parts = pair.Split(':', 2);
                if (parts.Length == 2 && drinks.ContainsKey(parts[0]) && int.TryParse(parts[1], out int qty))
                {
                    drinks[parts[0]] = qty;
                }
            }
        }

        List<string> entries = new List<string>();
        foreach (KeyValuePair<string, int> kv in drinks)
        {
            if (kv.Value != 0)
            {
                entries.Add(kv.Key + ":" + kv.Value);
            }
        }
        string order = string.Join(",", entries);

        // Unlike Java (which has no supported way to do this), .NET fully
        //  supports setting the current process's own environment
        //  variable - Process is already the default target.
        Environment.SetEnvironmentVariable("MY_ORDERS", order, EnvironmentVariableTarget.Process);

        // Dump this process's own environment (reflecting the MY_ORDERS
        //  just set above) to a well-known file for an external observer
        //  to inspect while this program is paused below - deleted again
        //  once that observer is done and this program is about to exit.
        var dump = new StringBuilder();
        foreach (System.Collections.DictionaryEntry entry in Environment.GetEnvironmentVariables())
        {
            dump.Append(entry.Key).Append('=').Append(entry.Value).Append('\n');
        }
        File.WriteAllText("dump_env.out", dump.ToString());

        // Console.WriteLine already flushes Console.Out on .NET (verified
        //  empirically: the blocking ReadLine below still sees this line
        //  land first even under redirected/piped stdout) - no explicit
        //  Flush() needed, same conclusion Rust's n20.setvars.rs reached
        //  for its own Stdout.
        Console.WriteLine("MY_ORDERS set, Hit Return to continue");
        Console.ReadLine();

        File.Delete("dump_env.out");
    }
}
