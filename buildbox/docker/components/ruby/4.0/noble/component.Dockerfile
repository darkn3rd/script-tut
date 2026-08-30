COPY --from=component_ruby /usr/local/ /usr/local/
ENV GEM_HOME=/usr/local/bundle \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG=/usr/local/bundle
ENV PATH=/usr/local/bundle/bin:$PATH
RUN mkdir -p "$GEM_HOME" && chmod 1777 "$GEM_HOME"
