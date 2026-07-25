// testbox: title="manual Iterator (hasNext()/next())"
// Not public - see a00.output.java for why.
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

class F02Loop {
    public static void main(String[] args) {
        File dir = new File("dirtest");
        List<String> items = new ArrayList<>();
        for (String name : dir.list()) items.add(name);
        Collections.sort(items);

        // step through the iterator protocol a for-each loop desugars to
        Iterator<String> it = items.iterator();
        while (it.hasNext()) {
            String item = it.next();
            if (new File(dir, item).isDirectory())
                System.out.println(item + " is a directory");
            else
                System.out.println(item + " is not a directory");
        }
    }
}
