import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class D00Input {
    public static void main(String[] args) throws IOException {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Enter your name: ");
        String name = stdin.readLine();
        System.out.println("Hello " + name + "!");
    }
}
