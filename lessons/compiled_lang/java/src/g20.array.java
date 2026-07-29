// Not public - see a00.output.java for why.
class G20Array {
    public static void main(String[] args) {
        String[] nicknames = {"bob", "ed", "steve", "ralph", "joe", "deb", "kate"};

        System.out.println("The names are: ");
        for (int i = 0; i < nicknames.length; i++) {
            System.out.println(" nicknames[" + i + "]=" + nicknames[i]);
        }
    }
}
