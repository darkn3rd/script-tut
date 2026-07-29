import java.text.SimpleDateFormat;
import java.util.Date;

// Not public - see a00.output.java for why.
class I00Subroutine {
    static void showDate() {
        System.out.println("Today is " + new SimpleDateFormat("MMMM d, yyyy").format(new Date()) + ".");
    }

    public static void main(String[] args) {
        showDate();
    }
}
