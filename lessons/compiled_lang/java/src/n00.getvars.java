import java.net.InetAddress;
import java.net.UnknownHostException;

// Enumerate a fixed set of well-known environment variables, printing
//  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
//  as actual environment entries on every POSIX host (confirmed
//  directly on the other compiled languages here: missing on GitHub
//  Actions' ubuntu-latest runners) - fall back to Java's own portable
//  equivalent for each (System properties need no external command,
//  unlike cpp/go, which had to shell out or call native OS APIs) so this
//  stays reliable anywhere. USERNAME/USERPROFILE/TEMP/COMPUTERNAME are
//  Windows-only concepts with no POSIX equivalent - printed only when
//  actually present.
//
// Not public - see a00.output.java for why.
class N00Getvars {
    public static void main(String[] args) {
        String user = System.getenv("USER");
        if (user == null || user.isEmpty()) {
            user = System.getProperty("user.name", "");
        }

        String tmpdir = System.getenv("TMPDIR");
        if (tmpdir == null || tmpdir.isEmpty()) {
            tmpdir = System.getProperty("java.io.tmpdir", "");
        }

        String hostname = System.getenv("HOSTNAME");
        if (hostname == null || hostname.isEmpty()) {
            hostname = currentHostname();
        }

        String home = System.getenv("HOME");

        System.out.println("USER=" + user);
        System.out.println("HOME=" + (home == null ? "" : home));
        System.out.println("TMPDIR=" + tmpdir);
        System.out.println("HOSTNAME=" + hostname);

        printIfPresent("USERNAME");
        printIfPresent("USERPROFILE");
        printIfPresent("TEMP");
        printIfPresent("COMPUTERNAME");
    }

    private static void printIfPresent(String name) {
        String value = System.getenv(name);
        if (value != null) {
            System.out.println(name + "=" + value);
        }
    }

    // getlogin()/gethostname()-style native calls have no JDK equivalent -
    //  InetAddress.getLocalHost().getHostName() is the portable substitute
    //  Java itself provides. COMPUTERNAME is tried first when present
    //  since a DNS/network lookup can be slow or fail outright in a
    //  sandboxed CI runner (getLocalHost() can throw
    //  UnknownHostException when the machine's own hostname doesn't
    //  resolve).
    private static String currentHostname() {
        String computerName = System.getenv("COMPUTERNAME");
        if (computerName != null && !computerName.isEmpty()) {
            return computerName;
        }
        try {
            return InetAddress.getLocalHost().getHostName();
        } catch (UnknownHostException e) {
            return "";
        }
    }
}
