RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential clang curl ca-certificates gnupg pkg-config unzip wget xz-utils \
        libbz2-1.0 libffi8 libgdbm6t64 libgmp10 libreadline8 libssl3 \
        libsqlite3-0 libyaml-0-2 zlib1g \
    && rm -rf /var/lib/apt/lists/*
