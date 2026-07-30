import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class E00Branch {
    public static void main(String[] args) throws IOException {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Would you like a toast? [Yes/No]: ");
        String response = stdin.readLine();

        String message;
        if (response.equals("Yes"))
            message = "That's great!";
        else
            message = "How about a muffin?";

        System.out.println(message);
    }
}
