import java.io.IOException;

class E30Branch {
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

        if (selection == 1)
            System.out.println("You selected a Coffee");
        else if (selection == 2)
            System.out.println("You selected an Espresso");
        else if (selection == 3)
            System.out.println("You selected a Latte");
        else if (selection == 4)
            System.out.println("You selected a Machiato");
        else if (selection == 5)
            System.out.println("You selected a Capucino");
        else if (selection == 6)
            System.out.println("You selected a Mocha");
        else if (selection == 7)
            System.out.println("You selected a Tea");
        else
            System.out.println("You have not entered a valid selection");
    }
}
