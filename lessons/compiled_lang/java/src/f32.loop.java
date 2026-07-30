// testbox: title="for (;;) with break"
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class F32Loop {
    public static void main(String[] args) throws IOException {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        for (;;) {
            System.out.print("Enter your name (quit to exit): ");
            String answer = stdin.readLine();

            if (answer.equals("quit"))
                break;

            System.out.println("Hello " + answer + "!");
        }
    }
}
