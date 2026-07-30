// Not public - see a00.output.java for why.
class B20Formatting {
    public static void main(String[] args) {
        int number = 5;
        char character = 'a';
        String text = "This is a string";

        // Positional format specifiers (%1$d, %2$c, %3$s) in one combined
        //  format string - distinct from b10's three separate printf calls
        //  (mirrors lessons/compiled_lang/rust's b20.formatting.rs, which makes the
        //  same "one call, positional {0}/{1}/{2}" choice for this lesson).
        //  Explicit "\n", not "%n" - %n renders as "\r\n" on a Windows JVM,
        //  which would break the exact-string comparison test.
        String output = String.format("Number is %1$d.\nCharacter is '%2$c'.\nString is \"%3$s\".\n",
                number, character, text);

        System.out.print(output);
    }
}
