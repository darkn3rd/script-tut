// testbox: title="indexed for loop over List"
// Not public - see a00.output.java for why.
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

class F03Loop {
    public static void main(String[] args) {
        File dir = new File("dirtest");
        List<String> items = new ArrayList<>();
        for (String name : dir.list()) items.add(name);
        Collections.sort(items);

        // indexed for loop
        for (int i = 0; i < items.size(); i++) {
            String item = items.get(i);
            if (new File(dir, item).isDirectory())
                System.out.println(item + " is a directory");
            else
                System.out.println(item + " is not a directory");
        }
    }
}
