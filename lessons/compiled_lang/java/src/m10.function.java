// Not public - see a00.output.java for why.
class M10Function {
    static String capitalize(String s) {
        return s.toUpperCase();
    }

    public static void main(String[] args) {
        String s = "ibm";
        System.out.println("The current string is: \"" + s + "\".");

        String result = capitalize(s);
        System.out.println("The capitalized string is: \"" + result + "\".");
    }
}
