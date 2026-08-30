RUN apt-get update \
    && apt-get install -y --no-install-recommends tcl \
    && rm -rf /var/lib/apt/lists/*
