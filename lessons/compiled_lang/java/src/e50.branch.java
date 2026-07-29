import java.io.IOException;

class E50Branch {
    public static void main(String[] args) throws IOException {
        System.out.print("Input a character: ");
        char keypress = (char) System.in.read();

        // switch requires a single comparable value, not a pattern, so
        //  classify first and switch on the result
        int kind;
        if (Character.isUpperCase(keypress)) kind = 0;
        else if (Character.isLowerCase(keypress)) kind = 1;
        else if (Character.isDigit(keypress)) kind = 2;
        else kind = 3;

        switch (kind) {
            case 0: System.out.println("Uppercase letter"); break;
            case 1: System.out.println("Lowercase letter"); break;
            case 2: System.out.println("Digit"); break;
            default: System.out.println("Punctuation, whitespace, or other");
        }
    }
}
