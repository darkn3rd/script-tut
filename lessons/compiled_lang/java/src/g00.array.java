// Not public - see a00.output.java for why.
class G00Array {
    public static void main(String[] args) {
        // populate array one item at a time
        String[] nicknames = new String[7];
        nicknames[0] = "bob";
        nicknames[1] = "ed";
        nicknames[2] = "steve";
        nicknames[3] = "ralph";
        nicknames[4] = "joe";
        nicknames[5] = "deb";
        nicknames[6] = "kate";

        System.out.println("The total nicknames are: " + nicknames.length);
        System.out.println("The nicknames are: " + String.join(", ", nicknames));
    }
}
