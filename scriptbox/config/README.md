# Manifest Compiler

This area contains the **source of truth** for configurations that describe how to install languages and supporting tools on a system.

## What's here

* **Environment Platforms Mappings (EPM)** (`env.yml`): is an association between a platform key and versions of the system that are known to work.  The system and version are built from `uname` derived environment string.
* **Platform Provisioning Manifests (PPM)** declare series of steps and dependencies for eveyr package and tool a full setup that the platform needs.

## Supported Platforms

* Windows (`windows.yml`)
  * Cygwin (`cygwin.yml`)
  * MSYS2 (`msys2.yml`)
* Ubuntu 22 (`ubuntu2204.yml`)
* macOS (`macos.yml`) - not tested

The script `gen_install.rb` can contruct an installer script using a PPM. 

## Platform Provisioning Manifest format

The general structure of a manifest follows the directory structure of this repository:

* `global`
  * `cibox`
  * `lessons`
    * `compiled_lang`
    * `gen_scripts`
    * `shell_scripts`
    * `win_scripts`
  * `scriptbox`
  * `testbox`

Within these areas will be a tree of `packages` that are blocks that describe how to install a package or tool.

These key words include the following:

* General
   * `cmd` a single command to execute
   * `path` setup a path for the shell environment or windows environment
   * `system` indicates that the item comes pre-installed
   * `script` corresponds a full script specified in the `scripts` area
   * `feature` under windwos represents a feature that is enabled
   * `file` create a file with specified content and destination specified in the `files` area
   * `append` appends a line if it doesn't exist to destinations specified in the `appends` area
* Version Managers
   * `pyenv` vrsion manager for python
   * `rbenv`  version manager for ruby
   * `sdkman` version manager for installing Java platform based languages
* System Package Managers
   * `apt` debian/ubuntu package system 
   * `brew`, `cask`, `tap` are used with Hoembrew
   * `choco`, `choco_cyg` are used with Chocolatey
   * `pacman` used for managing packages on MSYS2 or Arch Linux
   * `cyg` used for managing packages on Cygwin
* Language Packages
   * `gem` for installing ruby gems
   * `cpan` and `cpanm` for installing perl modules

### Implicit Dependencies

The `packages` from node will be run in the order hierarchy, thus if the script is installing perl, it will have run though this order already:

1. **`global.packages[]`** includes homebrew install, chocolatey install, `apt update`
2. **`global.lessons.packages[]**` includes any installers that are cross cutting to all the langauges, such as sdkman for both `java` and `groovy`
3. **`global.lessons.gen_scripts.packages[]`** includes any dependencies needed for all general script packages, such as build-essentials.
4. **`global.lessons.gen_scripts.perl.packages[]`** are the explicit packages for **perl**. 

In each `packages` list, they are run in order, so for perl you have this for Ubuntu 22.04:

* `system: perl`, `script: ubuntu22_cpan_local_setup` - sets up local `cpan`
* `cpan: App::cpanminus` - installs `cpanm`
* `cpanm: Switch` - install perl module `Switch.pm`

### Explicit Dependencies

For dependencies that do not fit neatly into a hierarchy, you can use these key words: 

* `needs: X` - this step must install after whichever other step declares `meets: X` (first listed provider wins).
* `meets: X` - marks this step as the provider for any `needs: X` elsewhere.

Here's an example of that association: 

```yaml
groovy:
  packages:
    - brew: groovy
      needs: java          # waits for whichever step below provides "java"
...
java:
  packages:
    - tap: homebrew/cask-versions
    - cask: corretto@17
      meets: java           # groovy's needs: java resolves to this step
      script: macos_java_17_home   # runs right after the cask installs
```

### Script Library

Under the scripts key are a dictionary (hash) of reusable scripts indexed by the script name. These will have the following structure:

* `type`: the shell that runs the script, such as `powershell` or `bash`
* `cmd`: a single line or multline commands that make the script
* `elevated`: boolean to determine if the script is run in escalated privileges


## Compiling a manifest

Two entry points read these manifests, both in `../scripts/`:

* **`generate_install_script.rb <config.yml> [SECTION ...]`** - compiles a single manifest file. Optional `SECTION` arguments (dotted paths, with `{a,b}` brace-expansion) filter to just the parts of the tree you want, e.g. `testbox` or `lessons.{compiled_lang,shell_scripts}`. No environment check - it'll generate whatever you point it at.
* **`gen_installer.rb --platform NAME`** - merges *every* `config/*.yml` into one tree first (so a `scripts:` block split across files still resolves), then refuses to generate unless `env.yml` lists the machine's own detected environment as supported for that platform. Always compiles the full tree for that platform, no section filtering.

Either way, compiling is a three-stage pipeline: **manifest → dependency resolution → code generation**.

1. `resolve_order.rb` flattens the tree into an ordered list of steps, reorders anything with `needs:` to sit after its `meets:` provider, and drops exact duplicate steps.
2. `generate_install_script.rb`'s own `bash_install`/`powershell_install` turn each step into the real package-manager invocation for its dialect (bash or PowerShell, per the platform's own `shell:` setting).
3. The result is written to `../generated/<platform>_install.<sh|ps1>` - see [`../generated/README.md`](../generated/README.md).

Don't hand-edit anything in `generated/`; edit the manifest here and recompile instead.
