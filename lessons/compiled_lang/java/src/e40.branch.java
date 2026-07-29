import java.io.IOException;

class E40Branch {
    public static void main(String[] args) throws IOException {
        System.out.print(
            "Select an item from the menu.\n\n" +
            "  1 - Coffee\n" +
            "  2 - Espresso\n" +
            "  3 - Latte\n" +
            "  4 - Machiato\n" +
            "  5 - Capucino\n" +
            "  6 - Mocha\n" +
            "  7 - Tea\n\n" +
            "Make your selection: ");

        int selection = System.in.read() - '0';

        switch (selection) {
            case 1: System.out.println("You selected a Coffee"); break;
            case 2: System.out.println("You selected an Espresso"); break;
            case 3: System.out.println("You selected a Latte"); break;
            case 4: System.out.println("You selected a Machiato"); break;
            case 5: System.out.println("You selected a Capucino"); break;
            case 6: System.out.println("You selected a Mocha"); break;
            case 7: System.out.println("You selected a Tea"); break;
            default: System.out.println("You have not entered a valid selection");
        }
    }
}
