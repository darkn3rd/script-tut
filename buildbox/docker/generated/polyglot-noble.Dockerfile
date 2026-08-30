# syntax=docker/dockerfile:1

# Donor stages: only explicit language payloads are copied into the final Noble image.
# --- donor: python-3.14 ---
FROM python:3.14.7-slim-bookworm AS component_python

# --- donor: ruby-4.0 ---
FROM rubylang/ruby:4.0-noble AS component_ruby

# --- donor: perl-5.044 ---
FROM perl:5.44.0-slim-bookworm AS component_perl

# --- donor: golang-1.27 ---
FROM golang:1.27.0-bookworm AS component_golang

# --- donor: rust ---
FROM rust:1.98.0-bookworm AS component_rust
RUN rust_sysroot="$(rustc --print sysroot)" \
    && cp -a "$rust_sysroot" /opt/rust-toolchain

# --- donor: groovy-5.1 ---
FROM groovy:5.1.0-jdk17-noble AS component_groovy

FROM mcr.microsoft.com/dotnet/sdk:10.0-noble@sha256:e1ffd2a92ae84c1291bc1b6887501f8af98e6331e7af6d4c8d37168c5e87a64c AS final

ARG DEBIAN_FRONTEND=noninteractive
ARG POWERSHELL_VERSION=7.6.5
ARG POWERSHELL_SHA256=b34ab3b19acac1d3d4d0d3cfdb02acf62f457b0b6a962ff008132033f7566844

# --- component: ubuntu-shells ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends dash tcsh zsh \
    && rm -rf /var/lib/apt/lists/*

# --- component: ubuntu-compiled-toolchain ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential clang curl ca-certificates gnupg pkg-config unzip wget xz-utils \
        libbz2-1.0 libffi8 libgdbm6t64 libgmp10 libreadline8 libssl3 \
        libsqlite3-0 libyaml-0-2 zlib1g \
    && rm -rf /var/lib/apt/lists/*

# --- component: tcl ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends tcl \
    && rm -rf /var/lib/apt/lists/*

# --- component: python-3.14 ---
COPY --from=component_python /usr/local/ /usr/local/
ENV PATH=/usr/local/bin:$PATH

# --- component: ruby-4.0 ---
COPY --from=component_ruby /usr/local/ /usr/local/
ENV GEM_HOME=/usr/local/bundle \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG=/usr/local/bundle
ENV PATH=/usr/local/bundle/bin:$PATH
RUN mkdir -p "$GEM_HOME" && chmod 1777 "$GEM_HOME"

# --- component: perl-5.044 ---
COPY --from=component_perl /usr/local/ /usr/local/

# --- component: golang-1.27 ---
COPY --from=component_golang /usr/local/go/ /usr/local/go/
ENV GOPATH=/go \
    GOTOOLCHAIN=local
ENV PATH=/go/bin:/usr/local/go/bin:$PATH
RUN mkdir -p /go/src /go/bin && chmod -R 1777 /go

# --- component: rust ---
COPY --from=component_rust /opt/rust-toolchain/ /opt/rust-toolchain/
ENV PATH=/opt/rust-toolchain/bin:$PATH

# --- component: java-17-openjdk-noble ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends openjdk-17-jdk-headless \
    && rm -rf /var/lib/apt/lists/* \
    && java_home="$(dirname "$(dirname "$(readlink -f "$(command -v javac)")")")" \
    && ln -s "$java_home" /opt/java-openjdk
ENV JAVA_HOME=/opt/java-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

# --- component: groovy-5.1 ---
RUN java --version && javac --version
COPY --from=component_groovy /opt/groovy/ /opt/groovy/
ENV GROOVY_HOME=/opt/groovy
ENV PATH=$GROOVY_HOME/bin:$PATH

# --- component: php-noble ---
RUN apt-get update \
    && apt-get install -y --no-install-recommends php-cli \
    && rm -rf /var/lib/apt/lists/*

# --- component: powershell ---
RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in amd64) ps_arch=x64 ;; *) echo "unsupported PowerShell architecture: $arch" >&2; exit 1 ;; esac; \
    url="https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell-${POWERSHELL_VERSION}-linux-${ps_arch}.tar.gz"; \
    curl -fL "$url" -o /tmp/powershell.tar.gz; \
    echo "${POWERSHELL_SHA256} */tmp/powershell.tar.gz" | sha256sum --check --strict; \
    mkdir -p /opt/microsoft/powershell/7; \
    tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7; \
    chmod +x /opt/microsoft/powershell/7/pwsh; \
    ln -s /opt/microsoft/powershell/7/pwsh /usr/local/bin/pwsh; \
    rm /tmp/powershell.tar.gz; \
    pwsh --version

RUN mkdir -p /workspace
WORKDIR /workspace
RUN dotnet --version \
    && python3 --version \
    && ruby --version \
    && perl --version \
    && go version \
    && rustc --version \
    && cargo --version \
    && java --version \
    && javac --version \
    && groovy --version \
    && php --version \
    && pwsh -NoLogo -NoProfile -Command '$PSVersionTable.PSVersion' \
    && printf 'puts [info patchlevel]\n' | tclsh \
    && zsh --version \
    && tcsh --version
CMD ["/bin/bash"]
