RUN java --version && javac --version
COPY --from=component_groovy /opt/groovy/ /opt/groovy/
ENV GROOVY_HOME=/opt/groovy
ENV PATH=$GROOVY_HOME/bin:$PATH
