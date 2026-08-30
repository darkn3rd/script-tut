COPY --from=component_python /usr/local/ /usr/local/
ENV PATH=/usr/local/bin:$PATH
