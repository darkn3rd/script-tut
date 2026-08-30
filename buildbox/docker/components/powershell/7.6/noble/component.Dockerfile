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
