COPY --from=component_rust /opt/rust-toolchain/ /opt/rust-toolchain/
ENV PATH=/opt/rust-toolchain/bin:$PATH
