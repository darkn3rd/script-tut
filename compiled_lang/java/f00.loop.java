// testbox: title="enhanced for-each loop"
// Not public - see a00.output.java for why.
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

class F00Loop {
    public static void main(String[] args) {
        // File.list() order isn't guaranteed by the filesystem, so sort
        //  the names first
        File dir = new File("dirtest");
        List<String> items = new ArrayList<>();
        for (String name : dir.list()) items.add(name);
        Collections.sort(items);

        // enhanced for-each loop
        for (String item : items) {
            if (new File(dir, item).isDirectory())
                System.out.println(item + " is a directory");
            else
                System.out.println(item + " is not a directory");
        }
    }
}
