// Not public - see a00.output.java for why.
class J20Arguments {
    public static void main(String[] args) {
        System.out.println("The arguments passed are (reverse order):");
        for (int i = args.length - 1; i >= 0; i--) {
            System.out.println(" item " + (i + 1) + ": " + args[i]);
        }
    }
}
