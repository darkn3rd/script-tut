using System;

class N00Getvars
{
    // Enumerate a fixed set of well-known environment variables, printing
    //  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably
    //  set as actual environment entries on every POSIX host (confirmed
    //  directly: missing on GitHub Actions' ubuntu-latest runners) - fall
    //  back to .NET's own portable equivalent for each so this stays
    //  reliable anywhere, matching shell_scripts/bash/scripts/n00.getvars.bash's
    //  own fallback approach. USERNAME/USERPROFILE/TEMP/COMPUTERNAME are
    //  Windows-only concepts with no POSIX equivalent - printed only when
    //  actually present.
    static void Main()
    {
        string user = Environment.GetEnvironmentVariable("USER");
        if (string.IsNullOrEmpty(user))
        {
            user = Environment.UserName;
        }

        string tmpdir = Environment.GetEnvironmentVariable("TMPDIR");
        if (string.IsNullOrEmpty(tmpdir))
        {
            tmpdir = System.IO.Path.GetTempPath();
        }

        string hostname = Environment.GetEnvironmentVariable("HOSTNAME");
        if (string.IsNullOrEmpty(hostname))
        {
            hostname = Environment.MachineName;
        }

        Console.WriteLine("USER=" + user);
        Console.WriteLine("HOME=" + Environment.GetEnvironmentVariable("HOME"));
        Console.WriteLine("TMPDIR=" + tmpdir);
        Console.WriteLine("HOSTNAME=" + hostname);

        string v;
        if ((v = Environment.GetEnvironmentVariable("USERNAME")) != null)
        {
            Console.WriteLine("USERNAME=" + v);
        }
        if ((v = Environment.GetEnvironmentVariable("USERPROFILE")) != null)
        {
            Console.WriteLine("USERPROFILE=" + v);
        }
        if ((v = Environment.GetEnvironmentVariable("TEMP")) != null)
        {
            Console.WriteLine("TEMP=" + v);
        }
        if ((v = Environment.GetEnvironmentVariable("COMPUTERNAME")) != null)
        {
            Console.WriteLine("COMPUTERNAME=" + v);
        }
    }
}
