import java.util.LinkedHashMap;
import java.util.Map;
import java.util.stream.Collectors;

// Not public - see a00.output.java for why.
class H00Associative {
    public static void main(String[] args) {
        // create empty map
        Map<String, Integer> ages = new LinkedHashMap<>();
        // insert one element at a time
        ages.put("bob", 34);
        ages.put("ed", 58);
        ages.put("steve", 32);
        ages.put("ralph", 23);
        ages.put("deb", 46);
        ages.put("kate", 19);

        // enumerate and print keys
        System.out.println("Keys (names):  " + String.join(", ", ages.keySet()));
        // enumerate and print values
        String values = ages.values().stream().map(String::valueOf).collect(Collectors.joining(", "));
        System.out.println("Values (ages): " + values);
    }
}
