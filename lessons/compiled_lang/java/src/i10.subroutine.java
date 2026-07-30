class I10Subroutine {
    // static fields are directly visible and mutable from any static
    //  method in this class - no "global" keyword needed like Python.
    static int pond = 500;
    static int captured = 0;

    static void fish() {
        pond -= 150;
        captured += 150;
    }

    public static void main(String[] args) {
        System.out.println("We have " + pond + " in this pond.");

        fish();
        System.out.println("Fishing from the main pond... We now have " + pond + " in the main pond.");

        fish();
        System.out.println("Fishing from the main pond... We now have " + pond + " in the main pond.");

        fish();
        System.out.println("Fishing from the main pond... We now have " + pond + " in the main pond.");

        System.out.println("We now have a total of " + captured + " fish captured");
    }
}
