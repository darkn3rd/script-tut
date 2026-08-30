FROM rust:1.98.0-bookworm AS component_rust
RUN rust_sysroot="$(rustc --print sysroot)" \
    && cp -a "$rust_sysroot" /opt/rust-toolchain
