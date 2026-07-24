import java.util.LinkedHashMap;
import java.util.Map;

// Not public - see a00.output.java for why.
class H10Associative {
    public static void main(String[] args) {
        // initialize map with key/value pairs
        Map<String, Integer> ages = new LinkedHashMap<>(Map.of(
            "bob", 34, "ed", 58, "steve", 32, "ralph", 23
        ));
        // append another set of key/value pairs into map
        ages.putAll(Map.of("deb", 46, "kate", 19));

        // iterate through map by keys, print key/value pairs
        System.out.println("The ages are: ");
        for (String name : ages.keySet()) {
            System.out.println(" ages[" + name + "]=" + ages.get(name));
        }
    }
}
