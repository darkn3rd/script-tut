// testbox: title="for (;;) with continue"
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class F41Loop {
    public static void main(String[] args) throws IOException {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        for (;;) {
            System.out.print("Enter your name (quit to exit): ");
            String answer = stdin.readLine();

            if (answer.isBlank())
                continue;

            if (answer.equals("quit"))
                break;

            System.out.println("Hello " + answer + "!");
        }
    }
}
