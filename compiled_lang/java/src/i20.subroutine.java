class I20Subroutine {
    static int pond = 500; // never mutated - fish() only touches its own local copy
    static int captured = 0;

    static void fish() {
        int pond = 500; // shadows the static field for the rest of this method
        pond -= 150;
        captured += 150;
    }

    public static void main(String[] args) {
        System.out.println("We have " + pond + " in this pond.");

        fish();
        System.out.println("Fishing from a local pond... We now have " + pond + " in the main pond.");

        fish();
        System.out.println("Fishing from a local pond... We now have " + pond + " in the main pond.");

        fish();
        System.out.println("Fishing from a local pond... We now have " + pond + " in the main pond.");

        System.out.println("We now have a total of " + captured + " fish captured");
    }
}
