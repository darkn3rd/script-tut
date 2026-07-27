import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

// Not public - see a00.output.java for why.
class O10Options {
    private static void usage(PrintStream out, String scriptName) {
        out.println();
        out.println("Usage: " + scriptName + " [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]");
        out.println();
        out.println("  -c  Coffee");
        out.println("  -e  Espresso");
        out.println("  -l  Latte");
        out.println("  -k  Machiato");
        out.println("  -p  Capucino");
        out.println("  -m  Mocha");
        out.println("  -t  Tea");
        out.println("  -h  Display this help message");
        out.println("  -?  Display this help message");
        out.println();
    }

    public static void main(String[] args) {
        String scriptName = System.getProperty("invoked.as");

        if (args.length == 0) {
            usage(System.err, scriptName);
            System.exit(1);
            return;
        }

        List<String> orders = new ArrayList<>();
        for (String arg : args) {
            switch (arg) {
                case "-c": orders.add("coffee"); break;
                case "-e": orders.add("espresso"); break;
                case "-l": orders.add("latte"); break;
                case "-k": orders.add("macchiato"); break;
                case "-p": orders.add("capucino"); break;
                case "-m": orders.add("mocha"); break;
                case "-t": orders.add("tea"); break;
                case "-h":
                case "-?":
                    usage(System.out, scriptName);
                    return;
                default:
                    usage(System.err, scriptName);
                    System.exit(1);
                    return;
            }
        }

        System.out.println();
        System.out.println("You ordered: ");
        for (String order : orders) {
            System.out.println("* " + order);
        }
    }
}
