import java.io.File;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.TreeMap;

// Java has no supported way to mutate *this* running JVM's own live
//  environment - System.getenv() returns an unmodifiable Map, and unlike
//  every other language in this project there's no setenv()/os.Setenv()/
//  env::set_var() equivalent. A private-field reflection hack against
//  java.lang.ProcessEnvironment exists and is well documented online, but
//  was tried here first and confirmed to fail cleanly on this JDK
//  (17, Corretto) without a JVM-launch-time flag most lessons shouldn't
//  need:
//
//    java.lang.reflect.InaccessibleObjectException: Unable to make field
//    private static final java.lang.ProcessEnvironment
//    java.lang.ProcessEnvironment.theEnvironment accessible: module
//    java.base does not "opens java.lang" to unnamed module ...
//
//  Fixing that would mean passing --add-opens java.base/java.lang=
//  ALL-UNNAMED on every invocation - i.e. changing how ../Makefile's
//  generated launcher runs *every* lesson, not just this one, just to
//  support one hack-y private-field write. Not worth it (see
//  ../README.md's Java-specific note).
//
//  What Java *does* fully support is customizing a *child* process's
//  environment via ProcessBuilder.environment() - a real, public,
//  documented API, not a hack. So this lesson computes MY_ORDERS, then
//  re-launches itself as a child JVM with that variable actually set in
//  the child's environment, and hands the child real stdin/stdout/stderr
//  via inheritIO() so it's transparent to anything driving this program
//  from outside. The child then dumps *its own* genuine environment
//  (which really does contain MY_ORDERS - no faking involved) to
//  dump_env.out, prints the prompt, and blocks on stdin exactly like
//  every other language's n20.setvars.*.
//
// Not public - see a00.output.java for why.
class N20Setvars {
    private static final String[] DRINK_NAMES =
            { "Capucino", "Coffee", "Espresso", "Latte", "Machiato", "Mocha", "Tea" };

    public static void main(String[] args) throws Exception {
        if (args.length > 0 && args[0].equals("--child")) {
            runChild();
            return;
        }

        String order = buildOrder(args);

        String javaBin = ProcessHandle.current().info().command().orElse("java");
        List<String> cmd = new ArrayList<>();
        cmd.add(javaBin);
        cmd.add("-cp");
        cmd.add(System.getProperty("java.class.path"));
        cmd.add("N20Setvars");
        cmd.add("--child");

        ProcessBuilder pb = new ProcessBuilder(cmd);
        pb.environment().put("MY_ORDERS", order);
        pb.inheritIO();

        Process child = pb.start();
        System.exit(child.waitFor());
    }

    private static String buildOrder(String[] args) {
        TreeMap<String, Integer> drinks = new TreeMap<>();
        for (String name : DRINK_NAMES) {
            drinks.put(name, 0);
        }

        if (args.length == 0) {
            Random rnd = new Random();
            for (String key : drinks.keySet()) {
                drinks.put(key, rnd.nextInt(3));
            }
        } else {
            for (String pair : args) {
                String[] parts = pair.split(":", 2);
                drinks.put(parts[0], Integer.parseInt(parts[1]));
            }
        }

        List<String> entries = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : drinks.entrySet()) {
            if (entry.getValue() != 0) {
                entries.add(entry.getKey() + ":" + entry.getValue());
            }
        }
        return String.join(",", entries);
    }

    // This runs as the *child* process launched above - System.getenv()
    //  here genuinely reflects the MY_ORDERS the parent set via
    //  ProcessBuilder.environment(), no reflection or faking involved.
    private static void runChild() throws Exception {
        File dump = new File("dump_env.out");
        try (PrintWriter out = new PrintWriter(dump)) {
            for (Map.Entry<String, String> entry : System.getenv().entrySet()) {
                out.println(entry.getKey() + "=" + entry.getValue());
            }
        }

        System.out.println("MY_ORDERS set, Hit Return to continue");
        System.out.flush();

        System.in.read();

        dump.delete();
    }
}
