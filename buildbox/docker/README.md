# Docker Image Composer

This tree designs generated, layered Dockerfiles for development images. It
does not copy a monolithic installation script into an image and does not use
runtime language-version managers.

## Layout

```text
docker/
├── bases/          # Supported parent images and their provenance
├── components/     # Curated, reusable Dockerfile instruction fragments
├── profiles/       # Requested base + ordered component selections
├── schemas/        # Metadata contracts used by the generator
└── generated/      # Disposable generated Dockerfiles
```

The top-level organization is by image technology. Platform and release are
properties of a base or component rather than the first directory boundary.

## Initial target

The first profile is `profiles/polyglot-noble.yml`:

- Base: the supported .NET 10 SDK image for Ubuntu 24.04 Noble.
- Ubuntu packages: shells and common native compilation tools installed in a
  consolidated apt layer.
- Curated components: Python, Ruby, Perl, Go, Rust, Java, Groovy, PHP, and
  PowerShell.
- Java and Groovy remain separate. Groovy declares `needs: [java]`; its
  fragment verifies `java`/`javac` and installs only Groovy.
- Components install one selected language version into conventional image
  locations. They do not install asdf, rbenv, pyenv, RVM, SDKMAN, or another
  runtime selector.

## Compilation pipeline

```text
profile
   │
   ├── select base
   ├── load component metadata
   ├── reject incompatible lineage/release/architectures
   ├── resolve needs/provides
   ├── stable topological ordering
   ├── merge compatible apt groups
   └── render Dockerfile layers
```

The planned command is:

```bash
ruby buildbox/docker/generate_dockerfile.rb \
  buildbox/docker/profiles/polyglot-noble.yml \
  --output buildbox/docker/generated/polyglot-noble.Dockerfile
```

Generation must fail if a referenced base or component is missing, still
marked `planned`, does not support the target architecture, or has an unmet
capability. It must never silently omit a requested language.

## Desired versions and updates

`desired_versions.yml` separates update intent from component implementation.
Run:

```bash
ruby buildbox/docker/check_versions.rb
```

The checker compares pinned desired versions with authoritative upstream
channels. `--write` updates only the desired-version file; it does not silently
rewrite a component, checksum, provenance record, or generated Dockerfile.
Those changes still require review and a successful image build.

Ubuntu-provided Java and PHP use `track: ubuntu_noble`. They receive the newest
package revision available from the Noble apt repositories when the image is
built and therefore have no independent upstream language version for this
checker to rewrite. Reproducible releases can later record the resolved apt
package versions in generated build metadata without turning them into desired
version pins.

## Component boundary

An upstream Dockerfile is a reference implementation, not an includable
module. Each component contains a reviewed fragment derived from a pinned
upstream revision plus `provenance.yml` conforming to
`schemas/provenance.schema.yml`.

Retain when applicable:

- version, URL, checksum, and signature verification;
- build and runtime dependencies;
- installation and build-dependency cleanup;
- language-specific environment settings;
- smoke tests.

Do not import image-global instructions from a component:

- `FROM`;
- `CMD` or `ENTRYPOINT`;
- global `USER`, `WORKDIR`, or `VOLUME`;
- upstream-image user renames;
- a second base image's defaults and labels.

These are owned by the profile/final renderer.

## Layering rules

1. Emit the selected `FROM` once.
2. Install shared Ubuntu packages early and consolidate apt packages with the
   same lifecycle.
3. Keep each upstream language build and its dependency cleanup in its own
   logical layer. This preserves upstream `apt-mark` behavior and useful cache
   boundaries.
4. Builder stages are allowed for self-contained payloads such as Go, but the
   component must also declare final-stage runtime packages and environment.
5. Use Docker-native `ENV`, `WORKDIR`, and `USER`; never depend on interactive
   `.bashrc`/`.zshrc` loading.
6. End with an aggregate verification layer that exercises every provided
   capability.

## Provenance and updates

Every curated component records the upstream repository, commit, path,
license, supported base, architectures, and verification commands. Updates are
reviewed rather than scraped automatically:

1. Compare the pinned upstream revision with its current revision.
2. Port relevant changes into the fragment.
3. Review dependency and image-global changes explicitly.
4. Build all supported architectures.
5. Run component and aggregate smoke tests.
6. Update the pinned commit and review date.

This preserves upstream security work without treating complete Dockerfiles as
safe textual includes.

## Rockcraft

Rockcraft is a separate OCI-image build technology, not the source format of
this Docker generator. If adopted, it belongs at `buildbox/rockcraft/` beside
`docker/` and `packer/`. Canonical JDK rocks remain useful reference/provenance
material, but the initial Noble Java component will use either Ubuntu's
OpenJDK 17 package or the curated Eclipse Temurin Noble installation.
