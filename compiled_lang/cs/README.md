# Compiled Language Tutorial: C#

**Summary**: C# is a modern, multi-paradigm language created by Anders Hejlsberg at Microsoft, unveiled in 2000 and officially released in 2002 alongside .NET Framework 1.0 as Microsoft's answer to Java. For most of its life it was a Windows-only, closed-source language tied to the CLR. That changed with .NET Core (2016) and the unified .NET 5+ (2020): the runtime and compiler are now fully open source and genuinely cross-platform, running natively on Windows, macOS, and Linux. Today it spans web services (ASP.NET Core), desktop apps (WPF/WinForms/MAUI), game development (Unity), and cloud-native microservices.

C# has the following tools:

* **`csc`** is the C# compiler (rarely invoked directly for real projects - see [Notes](#notes) below)
* **`dotnet`** is the CLI: it builds, runs, tests, and packages .NET projects, and also manages SDK installation - playing the role `cargo` and `rustup` split between them in Rust
* **NuGet** is .NET's package manager (not needed by these lessons - they have zero external dependencies)

## 💡 Why Was It Created?

Microsoft .NET Framework 1.0 was first released on February 13, 2002. It was created to provide a unified programming model, simplify web and Windows application development, and introduce a managed runtime environment - the Common Language Runtime (CLR) - that solved common software bugs like memory management.

The .NET Framework was architecturally similar to the Java JDK, in that code is compiled to bytecode rather than being locked to a single machine's native binary format at compile time:

| Architectural Layer | Java Platform (JDK 1.4 era) | .NET 1.0 Platform (2002) |
| :--- | :--- | :--- |
| **Virtual Machine** | Java Virtual Machine (JVM) | Common Language Runtime (CLR) |
| **Intermediate Code** | Java Bytecode (`.class`) | Common Intermediate Language (CIL / MSIL) |
| **Execution Engine** | Mixed (Interpreter + Just-In-Time) | Strict Just-In-Time (JIT / Pre-JIT Compilation) |
| **Design Philosophy** | Single language, multi-platform (*"Write Once, Run Anywhere"*) | Multi-language, single-platform (*"Write in any language, run on Windows"*) |
| **Type System** | Java Type System (unified via `java.lang.Object`) | Common Type System (CTS, unified via `System.Object`) |
| **Value vs. Reference** | Primitive types cannot have methods or behave as objects | Primitives can be converted to objects cleanly via **Boxing/Unboxing** |
| **Base Class Library** | Java Development Kit (JDK Standard Library) | .NET Base Class Library (BCL) |
| **Memory Management** | Generational Garbage Collection (Tracing) | Mark-and-Compact Generational Garbage Collection |
| **Interoperability** | Java Native Interface (JNI) via native C wrapper layers | Platform Invoke (**P/Invoke**) and native COM Interop wrapper layers |
| **Component Assembly** | Java Archive (`.jar` files containing zipped bytecode) | Assemblies (`.dll`/`.exe` Portable Executable files containing metadata) |
| **Security Architecture** | Sandboxed applet execution security framework | Code Access Security (CAS) |
| **Web System Framework** | Java Servlets / JavaServer Pages (JSP) | ASP.NET Web Forms |
| **Enterprise Operations** | Enterprise JavaBeans (EJB) | Enterprise Services (`System.EnterpriseServices` via COM+) |
| **Data Engine Access** | Java Database Connectivity (JDBC) | ADO.NET (disconnected `DataSet` model) |

### Why?

Before .NET, Microsoft had split its own resources across several separate runtimes:

* Visual Basic Runtime (`MSVBVMxx.DLL`)
* COM (Component Object Model) runtime
* Microsoft Virtual Machine for Java (MSJVM)
* Native Win32 C/C++ runtime (`MSVCRT.DLL`)
* Windows Script Host (WSH) engine

...each with its own frameworks built on top: desktop UI (MFC, ATL, WTL), web (ASP, DNA), data access (DAO, ADO, RDO), components (COM+, MTS), and Visual Basic's own stack (the VB Forms Engine, ActiveX/OCX). MSJVM had its own equivalents too (WFC, J/Direct).

Maintaining all of these was expensive, and innovations in one runtime's framework couldn't be shared with the others - a lot of the same ground got reinvented repeatedly. .NET's answer was a single unifying model: code from different languages compiles to a shared bytecode, CIL (Common Intermediate Language), which runs on one application VM, the CLR, using a JIT compiler. Frameworks - and even individual classes - could finally be shared across languages instead of siloed per-runtime.

.NET originally supported a broader set of languages than just C# and VB.NET:

| Language | Syntax Equivalent | Released | Ended |
| :--- | :--- | :--- | :--- |
| **C#** | C++ / Java | 2002 | Active |
| **Visual Basic .NET** | Classic VB / BASIC | 2002 | Active |
| **F#** | OCaml / Functional | 2010 | Active |
| **JScript .NET** | JavaScript | 2002 | 2016 |
| **Visual J#** | Java | 2002 | 2007 |
| **IronPython** | Python | 2006 | Active (Community) |
| **IronRuby** | Ruby | 2010 | 2011 (Community) |

And the classic frameworks each had a direct .NET-era successor:

* **Visual Basic**: the VB Forms Engine → Windows Forms (WinForms); ActiveX/OCX controls → .NET User Controls.
* **MSJVM / Visual J++**: WFC (Windows Foundation Classes) → Windows Forms; J/Direct → P/Invoke.
* **Web**: Classic ASP (Active Server Pages) → ASP.NET Web Forms.
* **Data access**: ADO (ActiveX Data Objects) → ADO.NET.
* **Enterprise/components**: COM+/MTS → Enterprise Services; DCOM → .NET Remoting.

Because the compiled output was bytecode rather than a native binary, it was feasible to compile on one operating system and run on another, as long as the same libraries (assemblies) were available. Around 2014 this was genuinely usable in practice: the open-source Mono Project let you compile binaries on Mac OS X and run them on Windows 7, and vice versa. The community had built compatible pieces of the stack too - `mod_mono` for ASP.NET on Apache, and ADO.NET providers for MySQL, PostgreSQL (Npgsql), and SQLite.

.NET's purpose was never "write once, run everywhere" the way the JVM's was - it was to unify Microsoft's own fragmented runtimes. Within that original scope, the model has kept evolving; see [Notes](#notes) below for where that evolution led (Native AOT) and why this project's own Makefile uses it.

## Install

You need the [.NET SDK](https://dotnet.microsoft.com/download) - not just the runtime.

### General: dotnet-install script

Works on Linux, macOS, and Windows (PowerShell):

```bash
curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 10.0
```

### macOS: Homebrew

* [Source Release](https://github.com/dotnet/dotnet) (download + compile)
  ```bash
  # Download/Compile DotNet
  brew install dotnet@10     # Formula: runtime only (v10.0.302.tar.gz)
  export DOTNET_ROOT="$(brew --prefix dotnet)/libexec"
  export PATH="$PATH:$DOTNET_ROOT"
  ```
* [Binary Package Installer Release](https://dotnet.microsoft.com/en-us/download#macos)
   ```bash
   brew install dotnet-sdk # Cask: runtime + sdk (dotnet-sdk-10.0.302-osx-x64.pkg)
   ```

Either way, a Homebrew install lands outside the apphost's default search path (`/usr/local/share/dotnet`) - if a compiled lesson complains it "must install .NET to run this application" even though `dotnet --version` works, set `DOTNET_ROOT` as shown above (add it to your shell profile so it persists).

### Windows 11: Chocolatey / WinGet

You can install DotNet using [**Chocolatey**](https://chocolatey.org/) or [**WinGet**](https://github.com/microsoft/winget-cli/). Here's a list of the package names for DotNet 10:

| WinGet Package ID                         | Chocolatey Package ID          | Description               |
| :---------------------------------------- | :----------------------------- | :------------------------ |
| Microsoft.DotNet.Runtime.10               | dotnet-runtime-10.0.           | Base .NET Runtime 10.0    |
| Microsoft.DotNet.AspNetCore.10            | dotnet-aspnetcore-runtime-10.0 | ASP.NET Core Runtime 10.0 |
| Microsoft.DotNet.DesktopRuntime.10        | dotnet-desktopruntime-10.0     | .NET Desktop Runtime 10.0 |
| Microsoft.DotNet.SDK.10                   | dotnet-sdk-10.0                | .NET SDK 10.0 Development Kit  |

You will want to install the SDK to get the compiler:

* Installing with Chocolatey
  ```powershell
  choco install -y dotnet-sdk-10.0
  ```
* Installing with WinGet
  ```powershell
  winget install Microsoft.DotNet.SDK.10
  ```

### Windows (MSYS2)

```bash
pacman -S mingw-w64-ucrt-x86_64-dotnet-sdk
```

### Verify Installation

Confirm it's on PATH, and that it's the SDK (not just the runtime):

```bash
dotnet --version
dotnet --list-sdks
```

If `dotnet --version` fails with something like "no SDKs were found" even though `dotnet` itself exists, only the runtime is installed - you need the SDK specifically.

These lessons build with Native AOT (see [Notes](#notes)), which needs a native linker on top of the SDK - the same one cpp/ needs:

* **macOS**: `xcode-select --install` (you very likely already have this).
* **Linux**: `apt install clang` (or your distro's equivalent) - `gcc` also works.
* **Windows**: the MSVC Build Tools - see [cpp/README.md](../cpp/README.md#install)'s "Building with MSVC" section for how to get them.

## Building and Running

### Makefile

```bash
cd compiled_lang/cs
make
./bin/a00.output          # or .\bin\a00.output.exe on Windows
```

### Running Tests

You can build the binaries and run tests to verify:

```bash
rake
```

## Notes

There's no simple, version-independent way to invoke the compiler directly for a single file: a bare `csc` needs either a hand-built list of every BCL reference assembly it needs (fragile - roughly 240 files, and the exact list depends on the installed SDK's version) or Mono as a separate dependency (whose own compiled `.exe` still needs a wrapper to run on real POSIX, or `mono` prefixed by hand). Both were dead ends in practice.

Instead, the Makefile generates a minimal, throwaway `.csproj` for each lesson (into `target/` - you'll never see or touch it) and publishes it with `dotnet publish` and **Native AOT** (`<PublishAot>true</PublishAot>`) - ahead-of-time compilation straight to native machine code, the same general idea as `g++`/`rustc`. A plain console app has zero external package dependencies, so this needs no NuGet/network access.

This wasn't the first thing tried. A plain `dotnet build` also produces a "native apphost" - but that apphost is a small stub, not an actually self-contained binary: it looks for a same-named `.dll` (plus `.runtimeconfig.json`/`.deps.json`) sitting right next to itself and fails immediately ("The application to execute does not exist: ...") without them. Native AOT is what actually gets `bin/` down to one genuinely standalone executable per lesson, matching the other four languages here - the tradeoff is the native-linker requirement noted under [Install](#install), and that AOT compiles for one specific OS+architecture at a time rather than "any CPU" (the Makefile autodetects the current machine's Runtime Identifier via `dotnet --info` - see the Makefile itself).

## Visual Studio Extensions

* [C# Dev Kit](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csdevkit) (by Microsoft) — the official C#/.NET extension pack: IntelliSense, debugging, project/solution management, and test discovery.
* [C#](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp) (by Microsoft) — the underlying language server, usually pulled in automatically by C# Dev Kit.
* [.NET Install Tool](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.vscode-dotnet-runtime) — manages the SDK/runtime versions VS Code's own tooling needs, independent of whatever SDK you installed system-wide.

### Visual Studio Configuration

Open your settings file in VS Code (Cmd + Shift + P -> Preferences: Open User Settings (JSON)) and add these C#-specific configurations:

```json
{
  // 1. Format code automatically on save
  "[csharp]": {
    "editor.defaultFormatter": "ms-dotnettools.csharp",
    "editor.formatOnSave": true
  },

  // 2. Show inlay hints for inferred types and parameter names
  "dotnet.inlayHints.enableInlayHintsForTypes": true,
  "dotnet.inlayHints.enableInlayHintsForParameters": true,

  // 3. Organize usings automatically on save
  "editor.codeActionsOnSave": {
    "source.organizeImports": "always"
  }
}
```

### Visual Studio Debugging

C# Dev Kit's own debugger (`coreclr`) attaches to a managed process - it doesn't apply here, since a Native AOT binary (see [Notes](#notes)) has no managed runtime for it to attach to. To step through a lesson binary in `bin/`, use a native debugger instead, same as [cpp/README.md](../cpp/README.md#visual-studio-debugging)'s [CodeLLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb):

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "lldb",
      "request": "launch",
      "name": "Debug C# Lesson",
      "program": "${workspaceFolder}/bin/a00.output",
      "args": [],
      "cwd": "${workspaceFolder}"
    }
  ]
}
```

Swap `bin/a00.output` for whichever lesson binary you want to step through (build it first with `make`). You'll be stepping through native/disassembly rather than C# source line-by-line - useful for confirming AOT actually did what you expect, less useful as an everyday C# debugger.

## Further Reading

* [C# documentation](https://learn.microsoft.com/en-us/dotnet/csharp/) — official Microsoft Learn hub for the language.
* [.NET documentation](https://learn.microsoft.com/en-us/dotnet/) — the runtime, SDK, and standard library C# builds on.
* [Chocolatey vs Winget: Modern Windows Package Management for System Engineers](https://www.flowdevs.io/blog/post/chocolatey-vs-winget-modern-windows-package-management-for-system-engineers)
