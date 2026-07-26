// Not public - see a00.output.java for why.
class J00Arguments {
    public static void main(String[] args) {
        // args.length excludes the program name (unlike argv in C/C++) -
        //  the wrapper script's own Makefile-injected "invoked.as" system
        //  property stands in for argv[0] here (see ../Makefile).
        String scriptName = System.getProperty("invoked.as");

        if (args.length != 2) {
            System.err.println();
            System.err.println("You need to enter two numbers:");
            System.err.println();
            System.err.println("   Usage: " + scriptName + " [num1] [num2]");
            System.err.println();
        } else {
            int sum = Integer.parseInt(args[0]) + Integer.parseInt(args[1]);
            System.out.println("The sum of " + args[0] + " and " + args[1] + " is: " + sum + ".");
        }
    }
}
