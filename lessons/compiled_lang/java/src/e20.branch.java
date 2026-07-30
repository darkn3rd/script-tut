import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class E20Branch {
    public static void main(String[] args) throws IOException {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Input a number: ");
        int number = Integer.parseInt(stdin.readLine());

        if (number > 0)
            System.out.println("Number is greater than 0");
        else if (number < 0)
            System.out.println("Number is less than 0");
        else
            System.out.println("Number is 0");
    }
}
