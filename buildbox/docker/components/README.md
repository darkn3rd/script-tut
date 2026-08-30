# Component Inventory

Components are planned until their fragment has been ported from a pinned
upstream implementation, license/provenance reviewed, and the Noble build and
smoke tests pass. A generator must reject planned components.

| Component | Noble strategy | Capabilities |
|---|---|---|
| `ubuntu-shells` | apt: `dash`, `tcsh`, `zsh` | shell commands |
| `ubuntu-compiled-toolchain` | apt: `build-essential`, `clang`, `pkg-config` | `cc`, `c++`, `make` |
| `tcl` | Ubuntu apt | `tcl` |
| `python-3.14` | Curated official Python source-build logic | `python`, `python3`, `pip` |
| `ruby-4.0` | Curated official Ruby source-build logic | `ruby`, `gem`, `bundle` |
| `perl-5.044` | Curated current `main` Perl source-build logic | `perl`, `cpan` |
| `golang-1.27` | Verified Go payload/build stage plus CGO dependencies | `go` |
| `rust` | Curated official Rust image logic; no runtime version switching | `rustc`, `cargo` |
| `java-17` | Ubuntu OpenJDK 17 or curated Temurin Noble component | `java 17`, `javac 17` |
| `groovy-5.1` | Binary distribution; assumes and verifies Java | `groovy 5.1` |
| `php` | Initially Ubuntu `php-cli`, exact source component later if needed | `php` |
| `powershell` | Checksummed upstream Linux release archive | `pwsh` |

The component identifier names a single selected variant. For example,
`perl-5.044` uses the current ordinary `main` implementation; the older
slim/threaded reference is not an additional component in this profile.

## Planned component tree

```text
components/
├── ubuntu-packages/noble/
├── python/3.14/noble/
├── ruby/4.0/noble/
├── perl/5.044/noble/
├── golang/1.27/noble/
├── rust/<version>/noble/
├── java/17/temurin-noble/
├── groovy/5.1/java17/
├── php/<version>/noble/
└── powershell/<version>/noble/
```

Each leaf will contain:

```text
component.Dockerfile
provenance.yml
verify.sh                  # only when verification needs more than commands
NOTICE                     # when required by upstream licensing
```
