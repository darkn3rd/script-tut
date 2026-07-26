# Compiled Language Tutorial: Java

**Summary**: Java was created by James Gosling and team at Sun Microsystems, starting in 1991 as "Oak" (originally aimed at embedded/set-top-box devices) and released publicly under the Java name in 1995. Oracle has owned it since acquiring Sun in 2010. Its defining idea - compile to portable JVM bytecode instead of native machine code - made "write once, run anywhere" real, and it became (and largely remains) the default choice for enterprise backend systems, Android app development, and large-team codebases.

Java has the following tools:

* **`javac`** is the compiler, producing JVM bytecode (`.class` files), not a native binary
* **`java`** is the JVM launcher that runs compiled bytecode
* **Maven** or **Gradle** are the standard build/package managers for real projects (not used by these lessons - see [Writing a Lesson](#writing-a-lesson) below for why a plain `javac`/`java` pair is enough here)
* **SDKMAN!** is the de facto version manager for the JVM ecosystem (Java, Kotlin, Gradle, Maven, ...) - the closest equivalent to `rustup`

## 💡 Why Was It Created?

Sun wanted a language that ran identically across the wildly different embedded hardware of the early 1990s, and later - once the web arrived - across every user's browser and OS without recompiling.

1. **"Write Once, Run Anywhere"**: `javac` compiles to JVM bytecode rather than native machine code, so the same compiled artifact runs unmodified on any platform with a JVM.
2. **Automatic Memory Management**: garbage collection removes the manual `malloc`/`free` bugs that plagued C and C++ codebases of the era.
3. **Strong, Static Typing for Large Teams**: a verbose-by-design, strongly-typed OOP language was seen as easier to maintain across large teams and codebases than C++'s more freeform style.
4. **A Huge Standard Library and Ecosystem**: the JDK's batteries-included standard library, and later Maven Central, made Java a safe default for enterprise software - and for years, the official language for Android development.

## Install

Any recent JDK - what's used here was [Amazon Corretto](https://aws.amazon.com/corretto/) 17, but any JDK 15+ works (a20/b30 use text blocks, `"""`, a standard - non-preview - feature only since Java 15).

* **Windows (MSYS2)**: `pacman -S mingw-w64-ucrt-x86_64-openjdk`, or install any JDK distribution directly and add its `bin` to PATH.
* **macOS**: `brew install openjdk`.
* **Linux**: your distro's package, e.g. `apt install default-jdk`.
* **Any platform, via SDKMAN!**:
  ```bash
  curl -s "https://get.sdkman.io" | bash
  sdk install java 17.0.16-amzn
  ```

### Verify Installation

Confirm `javac` and `java` are both on PATH:

```bash
javac -version
java -version
```

## Building and Running

### Makefile

```bash
cd compiled_lang/java
make
./bin/a00.output          # or .\bin\a00.output.bat on Windows
```

### Running Tests

You can build the binaries and run tests to verify:

```bash
rake
```

## Writing a Lesson

Java has no single-file "compile straight to a native binary" option, and `javac`'s own output is named after the *class declared inside the file*, not the source file - so a lesson file like `a00.output.java` can't contain a `public class A00Output` (a `public` top-level class's file name is required to match the class name exactly, and Java identifiers can't contain the dots this project's lesson names use). Instead, declare the class **without** `public`:

```java
class A00Output {
    public static void main(String[] args) {
        System.out.println("Hello");
    }
}
```

The Makefile compiles this into `target/` (`javac -d target src/a00.output.java` -> `target/A00Output.class`), then generates a launcher at `bin/a00.output` (or `bin/a00.output.bat` on Windows) that runs `java -cp <path-to-target> A00Output` - that launcher, not the `.class` file, is what the test harness actually invokes. It finds the class name by grepping the source for the first `class Name` declaration, so keep to one top-level class per lesson file.

## Visual Studio Extensions

* [Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack) (by Microsoft) — bundles everything below into one install.
  * [Language Support for Java](https://marketplace.visualstudio.com/items?itemName=redhat.java) (by Red Hat) — IntelliSense, refactoring, and code navigation.
  * [Debugger for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug)
  * [Test Runner for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-test)
  * [Project Manager for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-dependency) and [Maven for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-maven) — not needed by these lessons (no project files, no Maven), but part of the standard pack.

### Visual Studio Configuration

Open your settings file in VS Code (Cmd + Shift + P -> Preferences: Open User Settings (JSON)) and add these Java-specific configurations:

```json
{
  // 1. Format code automatically on save
  "[java]": {
    "editor.defaultFormatter": "redhat.java",
    "editor.formatOnSave": true
  },

  // 2. Point the extension at the JDK these lessons were built against
  "java.configuration.runtimes": [
    {
      "name": "JavaSE-17",
      "path": "/usr/local/opt/openjdk",
      "default": true
    }
  ],

  // 3. Show inlay hints for parameter names
  "java.inlayHints.parameterNames.enabled": "all"
}
```

(adjust `java.configuration.runtimes[0].path` to wherever your JDK actually lives - `brew --prefix openjdk` on macOS, or your distro's JDK install path on Linux)

### Visual Studio Debugging

To enable step-by-step debugging of a compiled lesson class in VS Code, add a `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "java",
      "name": "Debug Java Lesson",
      "request": "launch",
      "mainClass": "A00Output",
      "cwd": "${workspaceFolder}/bin"
    }
  ]
}
```

Swap `mainClass` for whichever lesson's class name you want to step through (see [Writing a Lesson](#writing-a-lesson) above for how a source file maps to a class name).

## Further Reading

* [dev.java](https://dev.java/) — Oracle's official Java learning/documentation portal.
* [Oracle Java Documentation](https://docs.oracle.com/en/java/) — the full JDK/JLS reference set.
