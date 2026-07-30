# Notes

## Buffered Reader

### Won't Work as unbuffered

```groovy
#!/usr/bin/env groovy
name = System.console().readLine "Enter your name: "
printf "Hello %s!\n", name
```

```bash
$ echo "John Doe" | ./helloname.groovy
Caught: java.lang.NullPointerException: Cannot invoke method readLine() on null object
java.lang.NullPointerException: Cannot invoke method readLine() on null object
at helloname.run(helloname.groovy:2)
```

```bash
$ echo Hello > sometext
$ groovy helloname.groovy < sometext
Caught: java.lang.NullPointerException: Cannot invoke method readLine() on null object
java.lang.NullPointerException: Cannot invoke method readLine() on null object
at helloname.run(helloname.groovy:2)
```

### Should work as buffered

```groovy
#!/usr/bin/env groovy
import java.util.Scanner

name = new Scanner(System.in).nextLine()
printf "Hello %s!\n", name
```

```bash
$ echo "John Doe" | ./helloname.groovy
Hello John Doe!
```

```bash
$ echo Hello > sometext; ./helloname.groovy < sometext
Hello Hello!
```
