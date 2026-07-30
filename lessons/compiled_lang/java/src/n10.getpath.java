import java.util.regex.Pattern;

// Not public - see a00.output.java for why.
class N10Getpath {
    public static void main(String[] args) {
        String path = System.getenv("PATH");
        if (path == null) {
            path = "";
        }

        // path.separator is Java's own portable equivalent of splitting on
        //  the OS's PATH list separator (";" on Windows, ":" on POSIX) -
        //  no need to hardcode either.
        String separator = System.getProperty("path.separator", ":");
        for (String dir : path.split(Pattern.quote(separator), -1)) {
            System.out.println(dir);
        }
    }
}
