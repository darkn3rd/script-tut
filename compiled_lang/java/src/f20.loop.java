// testbox: title="while loop"
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class F20Loop {
    public static void main(String[] args) throws IOException {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        String answer = "";
        while (!answer.equals("quit")) {
            System.out.print("Enter your name (quit to Exit): ");
            answer = stdin.readLine();

            if (!answer.equals("quit"))
                System.out.println("Hello " + answer + "!");
        }
    }
}
