RUN apt-get update \
    && apt-get install -y --no-install-recommends dash tcsh zsh \
    && rm -rf /var/lib/apt/lists/*
