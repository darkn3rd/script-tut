// testbox: title="for loop as conditional loop"
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class F21Loop {
    public static void main(String[] args) throws IOException {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));

        // the for statement's own update clause is left empty - answer is
        //  reassigned in the body instead, so the loop's only real job
        //  here is testing the condition before each pass
        for (String answer = ""; !answer.equals("quit"); ) {
            System.out.print("Enter your name (quit to Exit): ");
            answer = stdin.readLine();

            if (!answer.equals("quit"))
                System.out.println("Hello " + answer + "!");
        }
    }
}
