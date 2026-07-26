// Not public - see a00.output.java for why.
class J10Arguments {
    public static void main(String[] args) {
        System.out.println("The arguments passed are:");
        for (int i = 0; i < args.length; i++) {
            System.out.println(" item " + (i + 1) + ": " + args[i]);
        }
    }
}
