RUN apt-get update \
    && apt-get install -y --no-install-recommends openjdk-17-jdk-headless \
    && rm -rf /var/lib/apt/lists/* \
    && java_home="$(dirname "$(dirname "$(readlink -f "$(command -v javac)")")")" \
    && ln -s "$java_home" /opt/java-openjdk
ENV JAVA_HOME=/opt/java-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH
