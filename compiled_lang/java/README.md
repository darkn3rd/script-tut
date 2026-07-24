# Scripting Tutorial: Java

See [../README.md](../README.md) for the shared convention (naming, `make`, how `rake` drives the build).

## Install

Any recent JDK - what's used here was [Amazon Corretto](https://aws.amazon.com/corretto/) 17, but any JDK 11+ works.

* **Windows (MSYS2)**: `pacman -S mingw-w64-ucrt-x86_64-openjdk`, or install any JDK distribution directly and add its `bin` to PATH.
* **macOS**: `brew install openjdk`.
* **Linux**: your distro's package, e.g. `apt install default-jdk`.

Confirm `javac` and `java` are both on PATH:

```bash
javac -version
java -version
```

## Build and run by hand

```bash
cd compiled_lang/java
make
./bin/a00.output          # or .\bin\a00.output.bat on Windows
```

## Writing a lesson

Java has no single-file "compile straight to a native binary" option, and `javac`'s own output is named after the *class declared inside the file*, not the source file - so a lesson file like `a00.output.java` can't contain a `public class A00Output` (a `public` top-level class's file name is required to match the class name exactly, and Java identifiers can't contain the dots this project's lesson names use). Instead, declare the class **without** `public`:

```java
class A00Output {
    public static void main(String[] args) {
        System.out.println("Hello");
    }
}
```

The Makefile compiles this into `bin/` (`javac -d bin a00.output.java` -> `bin/A00Output.class`), then generates a launcher at `bin/a00.output` (or `bin/a00.output.bat` on Windows) that runs `java -cp . A00Output` - that launcher, not the `.class` file, is what the test harness actually invokes. It finds the class name by grepping the source for the first `class Name` declaration, so keep to one top-level class per lesson file.
