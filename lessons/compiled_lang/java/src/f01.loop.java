// testbox: title="List.forEach() with lambda"
// Not public - see a00.output.java for why.
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

class F01Loop {
    public static void main(String[] args) {
        File dir = new File("dirtest");
        List<String> items = new ArrayList<>();
        for (String name : dir.list()) items.add(name);
        Collections.sort(items);

        // List.forEach() with a lambda
        items.forEach(item -> {
            if (new File(dir, item).isDirectory())
                System.out.println(item + " is a directory");
            else
                System.out.println(item + " is not a directory");
        });
    }
}
