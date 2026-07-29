import java.io.PrintStream;

// Not public - see a00.output.java for why.
class O00Flags {
    private static void usage(PrintStream out, String scriptName) {
        out.println();
        out.println("Usage: " + scriptName + " [-c|-e|-l|-k|-p|-m|-t] [-h|-?]");
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
        // the wrapper script's own Makefile-injected "invoked.as" system
        //  property stands in for argv[0] here (see ../Makefile).
        String scriptName = System.getProperty("invoked.as");

        if (args.length == 0) {
            usage(System.err, scriptName);
            System.exit(1);
            return;
        }

        switch (args[0]) {
            case "-c":
                System.out.println("You ordered a Coffee.");
                break;
            case "-e":
                System.out.println("You ordered an Espresso.");
                break;
            case "-l":
                System.out.println("You ordered a Latte.");
                break;
            case "-k":
                System.out.println("You ordered a Machiato.");
                break;
            case "-p":
                System.out.println("You ordered a Capucino.");
                break;
            case "-m":
                System.out.println("You ordered a Mocha.");
                break;
            case "-t":
                System.out.println("You ordered a Tea.");
                break;
            case "-h":
            case "-?":
                usage(System.out, scriptName);
                break;
            default:
                usage(System.err, scriptName);
                System.exit(1);
        }
    }
}
