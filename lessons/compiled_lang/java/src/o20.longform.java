import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

// Not public - see a00.output.java for why.
class O20Longform {
    private static void usage(PrintStream out, String scriptName) {
        out.println();
        out.println("Usage: " + scriptName + " [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]");
        out.println();
        out.println("  --coffee,    -c N  Coffee");
        out.println("  --espresso,  -e N  Espresso");
        out.println("  --latte,     -l N  Latte");
        out.println("  --macchiato, -k N  Machiato");
        out.println("  --capucino,  -p N  Capucino");
        out.println("  --mocha,     -m N  Mocha");
        out.println("  --tea,       -t N  Tea");
        out.println("  --help,      -h    Display this help message");
        out.println("  -?                 Display this help message");
        out.println();
    }

    public static void main(String[] args) {
        String scriptName = System.getProperty("invoked.as");

        if (args.length == 0) {
            usage(System.err, scriptName);
            System.exit(1);
            return;
        }

        List<String> names = new ArrayList<>();
        List<String> counts = new ArrayList<>();

        int i = 0;
        while (i < args.length) {
            switch (args[i]) {
                case "--coffee": case "-c":
                    names.add("coffee"); counts.add(args[i + 1]); i += 2; break;
                case "--espresso": case "-e":
                    names.add("espresso"); counts.add(args[i + 1]); i += 2; break;
                case "--latte": case "-l":
                    names.add("latte"); counts.add(args[i + 1]); i += 2; break;
                case "--macchiato": case "-k":
                    names.add("macchiato"); counts.add(args[i + 1]); i += 2; break;
                case "--capucino": case "-p":
                    names.add("capucino"); counts.add(args[i + 1]); i += 2; break;
                case "--mocha": case "-m":
                    names.add("mocha"); counts.add(args[i + 1]); i += 2; break;
                case "--tea": case "-t":
                    names.add("tea"); counts.add(args[i + 1]); i += 2; break;
                case "--help": case "-h": case "-?":
                    usage(System.out, scriptName);
                    return;
                default:
                    usage(System.err, scriptName);
                    System.exit(1);
                    return;
            }
        }

        if (names.isEmpty()) {
            usage(System.err, scriptName);
            System.exit(1);
            return;
        }

        System.out.println();
        System.out.println("You ordered: ");
        for (int idx = 0; idx < names.size(); idx++) {
            int n = Integer.parseInt(counts.get(idx));
            String label = names.get(idx);
            if (n != 1) label += "s";
            System.out.println("* " + counts.get(idx) + " " + label);
        }
    }
}
