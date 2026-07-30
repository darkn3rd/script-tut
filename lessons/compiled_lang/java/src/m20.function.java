import java.util.Arrays;

// Not public - see a00.output.java for why.
class M20Function {
    static String[] sortArray(String[] array) {
        String[] result = array.clone();
        Arrays.sort(result);
        return result;
    }

    public static void main(String[] args) {
        String[] array = {"bob", "ed", "steve", "ralph", "joe", "deb", "kate"};
        System.out.println("Current names are: " + String.join(", ", array));

        String[] result = sortArray(array);
        System.out.println("Sorted names are: " + String.join(", ", result));
    }
}
