import java.io.IOException;

// Not public - see a00.output.java for why.
class D10Input {
    public static void main(String[] args) throws IOException {
        System.out.print("Input a character: ");
        // System.in.read() reads a single raw byte (as an int, -1 at EOF) -
        //  works fine against a piped/non-interactive stdin, no raw
        //  terminal mode needed.
        char character = (char) System.in.read();
        System.out.println("You entered: >>|" + character + "|<<.");
    }
}
