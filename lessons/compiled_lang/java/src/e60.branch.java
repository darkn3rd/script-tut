import java.io.IOException;

class E60Branch {
    public static void main(String[] args) throws IOException {
        System.out.print("Input a character: ");
        char keypress = (char) System.in.read();
        String s = String.valueOf(keypress);

        if (s.matches("[A-Z]"))
            System.out.println("Uppercase letter");
        else if (s.matches("[a-z]"))
            System.out.println("Lowercase letter");
        else if (s.matches("[0-9]"))
            System.out.println("Digit");
        else
            System.out.println("Punctuation, whitespace, or other");
    }
}
