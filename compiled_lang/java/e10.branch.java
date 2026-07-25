import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class E10Branch {
    public static void main(String[] args) throws IOException {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Would you like a toast? [Yes/No]: ");
        String response = stdin.readLine();

        // Java's ternary operator
        String message = response.equals("Yes") ? "That's great!" : "How about a muffin?";

        System.out.println(message);
    }
}
