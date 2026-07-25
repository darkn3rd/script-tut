# Compiled Language Tutorial: C#

**Summary**: C# is a modern, multi-paradigm language created by Anders Hejlsberg at Microsoft, unveiled in 2000 and officially released in 2002 alongside .NET Framework 1.0 as Microsoft's answer to Java. For most of its life it was a Windows-only, closed-source language tied to the CLR. That changed with .NET Core (2016) and the unified .NET 5+ (2020): the runtime and compiler are now fully open source and genuinely cross-platform, running natively on Windows, macOS, and Linux. Today it spans web services (ASP.NET Core), desktop apps (WPF/WinForms/MAUI), game development (Unity), and cloud-native microservices.

C# has the following tools:

* **`csc`** is the C# compiler (rarely invoked directly for real projects - see [Notes](#notes) below)
* **`dotnet`** is the CLI: it builds, runs, tests, and packages .NET projects, and also manages SDK installation - playing the role `cargo` and `rustup` split between them in Rust
* **NuGet** is .NET's package manager (not needed by these lessons - they have zero external dependencies)

## 💡 Why Was It Created?

Microsoft needed a first-class, modern language for its new .NET runtime: C and C++ offered no memory safety or garbage collection, and licensing/legal friction with Sun over Microsoft's own extended dialect of Java (J++) made a Java dependency untenable long-term.

1. **Type Safety + Managed Memory**: C# runs on the Common Language Runtime (CLR), which handles garbage collection and JIT compilation - the same role the JVM plays for Java - eliminating whole categories of manual-memory bugs.
2. **Rapid, Batteries-Included Development**: one language spans web (ASP.NET Core), desktop (WPF/WinForms/MAUI), games (Unity), and cloud services (Azure Functions), backed by a large standard library and the NuGet ecosystem.
3. **Cross-Platform Reinvention**: starting with .NET Core and unified in .NET 5+, Microsoft rebuilt the runtime as open-source and cross-platform, ending C#'s Windows-only past.
4. **Evolving Fast**: modern C# (pattern-matching switches, records, nullable reference types, top-level statements) has closed much of the gap with newer languages while staying backward compatible.

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

Instead, the Makefile generates a minimal, throwaway `.csproj` for each lesson and builds it with `dotnet build`. A plain console app has zero external package dependencies, so this needs no NuGet/network access - `dotnet build` resolves everything from the installed SDK alone - and it produces a genuine native apphost, not a "needs a host to run it" managed exe, so (unlike the Mono path) no wrapper script is needed on Windows *or* real POSIX. This is the one language here that needs a project file rather than a truly bare single-file compile, but it's generated automatically - you'll never see or touch it.

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

To debug a compiled lesson binary directly with C# Dev Kit's debugger, add a `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": ".NET: Debug Lesson",
      "type": "coreclr",
      "request": "launch",
      "program": "${workspaceFolder}/bin/a00.output.dll",
      "cwd": "${workspaceFolder}",
      "console": "internalConsole"
    }
  ]
}
```

Swap `a00.output.dll` for whichever lesson's built `.dll` (in `bin/`, alongside the native apphost) you want to step through.

## Further Reading

* [C# documentation](https://learn.microsoft.com/en-us/dotnet/csharp/) — official Microsoft Learn hub for the language.
* [.NET documentation](https://learn.microsoft.com/en-us/dotnet/) — the runtime, SDK, and standard library C# builds on.
* [Chocolatey vs Winget: Modern Windows Package Management for System Engineers](https://www.flowdevs.io/blog/post/chocolatey-vs-winget-modern-windows-package-management-for-system-engineers)
