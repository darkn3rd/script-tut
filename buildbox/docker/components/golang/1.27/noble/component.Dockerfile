COPY --from=component_golang /usr/local/go/ /usr/local/go/
ENV GOPATH=/go \
    GOTOOLCHAIN=local
ENV PATH=/go/bin:/usr/local/go/bin:$PATH
RUN mkdir -p /go/src /go/bin && chmod -R 1777 /go
