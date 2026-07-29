// testbox: title="IntStream.forEach() (stream API)"
import java.util.Comparator;
import java.util.stream.IntStream;

class F13Loop {
    public static void main(String[] args) {
        // stream API - box to Integer so it can be sorted in reverse order
        IntStream.rangeClosed(1, 10)
                 .boxed()
                 .sorted(Comparator.reverseOrder())
                 .forEach(count -> System.out.println("Count is " + count));
    }
}
