// Not public - see a00.output.java for why.
class L00Exit {
    static final int EX_USAGE = 64;
    static final int EX_OK = 0;

    static void usageMessage(String scriptName) {
        System.err.println();
        System.err.println("You need to enter one or more numbers:");
        System.err.println();
        System.err.println("   Usage: " + scriptName + " [num1] [num2] [num3]...");
        System.err.println();
        System.exit(EX_USAGE);
    }

    static void addNums(String[] numbers) {
        int sum = 0;
        for (String num : numbers) {
            sum += Integer.parseInt(num);
        }
        System.out.println("The summation is: " + sum + ".");
        System.exit(EX_OK);
    }

    public static void main(String[] args) {
        // args.length excludes the program name (unlike argv in C/C++) -
        //  the wrapper script's own Makefile-injected "invoked.as" system
        //  property stands in for argv[0] here (see ../Makefile).
        String scriptName = System.getProperty("invoked.as");

        if (args.length < 1) {
            usageMessage(scriptName);
        } else {
            addNums(args);
        }
    }
}
