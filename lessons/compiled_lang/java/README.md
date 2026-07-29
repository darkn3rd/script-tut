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

## Getting Java JDK

There a few offerings of Java JDK:

* [Amazon Corretto](https://aws.amazon.com/corretto/) OpenJDK
* [Zulu](https://www.azul.com/downloads/?package=jdk#zulu) OpenJDK
* [Termurin](https://adoptium.net/) OpenJDK
* [Oracle Java JDK](https://www.oracle.com/java/technologies/downloads/)

### Windows 11: Chocolatey

You can use [**Chocolatey**](https://chocolatey.org/) to install, for example: [Amazon Corretto 17](https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/downloads-list.html)

```powershell
choco install -y corretto17jdk
```

### MSYS2 (Windows 11)

MSYS2 does not provide first-party packages for a full OpenJDK/JDK.  You can point to your existing Java installation using this method:

```bash
cat >> ~/.bashrc <<'EOF'

# Amazon Corretto JDK 17
export JAVA_HOME='/c/Program Files/Amazon Corretto/jdk17.0.19_10'
export PATH="$JAVA_HOME/bin:$PATH"
EOF

source ~/.bashrc
```

### macOS: Homebrew

You can use [**Homebrew**](https://brew.sh/) to install, for example: [Amazon Corretto 17](https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/downloads-list.html)

```bash
brew tap homebrew/cask-versions
brew install --cask corretto@17
# add this to startup profile, ~/.zprofile or ~/.bashrc
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

```

### Ubuntu 22.04 Jammy Jellyfish

```bash
KEYRING="/usr/share/keyrings/corretto-keyring.gpg"
wget -O - https://apt.corretto.aws/corretto.key \
  | sudo gpg --dearmor -o $KEYRING
echo "deb [signed-by=$KEYRING] https://apt.corretto.aws stable main" \
  | sudo tee /etc/apt/sources.list.d/corretto.list
sudo apt update && sudo apt install -y java-17-amazon-corretto-jdk

# add this to startup profile: ~/.zshrc or ~/.bashrc
export JAVA_HOME=$(readlink -f /usr/bin/java | sed 's|/bin/java||')

```

If you need to manage multiple Java versions, you can configure the desired ones with:

```bash
sudo update-alternatives --config java
sudo update-alternatives --config javac
```

export JAVA_HOME=$(readlink -f /usr/bin/javac | sed 's|/bin/javac||')


### SDKMAN!

On macOS and Linux with **[SDKMAN!](https://sdkman.io/)** install, you can use this to install Java JDK.  Below is an example of installing [Amazon Corretto 17](https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/downloads-list.html).

```bash
# Install OpenJDK
sdk install java 17.0.19-amzn
sdk default java 17.0.19-amzn
```

### ASDF

On macOS and Linux, you can use ASDF to install a Java JDK. Below is an example of installing [Amazon Corretto 17](https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/downloads-list.html).

```bash
# Install Java
asdf plugin add java https://github.com/halcyon/asdf-java.git
asdf install java corretto-17.0.19.10.1
asdf global java corretto-17.0.19.10.1
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
cd lessons/compiled_lang/java
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

## Testing

* 📀 *__macOS 26.5 (Tahoe)__*
  * ⚙️ javac 17.0.20
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)


## Further Reading

* [dev.java](https://dev.java/) — Oracle's official Java learning/documentation portal.
* [Oracle Java Documentation](https://docs.oracle.com/en/java/) — the full JDK/JLS reference set.
* [Amazon Corretto 17 Installation Instructions for Debian-Based, RPM-Based and Alpine Linux Distributions](https://docs.aws.amazon.com/corretto/latest/corretto-17-ug/generic-linux-install.html)
* [New update channels for Amazon Corretto releases](https://aws.amazon.com/blogs/opensource/new-update-channels-for-amazon-corretto-releases/)