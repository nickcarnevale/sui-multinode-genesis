# Dockerfile for building sui-node binary from scratch and starting it
# with a configuration file.
#
FROM rust:1.79-bullseye AS builder
RUN apt-get update && apt-get install -y cmake clang
RUN git clone https://github.com/mystenlabs/sui
RUN apt-get install -y curl cmake gcc libssl-dev pkg-config libclang-dev libpq-dev build-essential

WORKDIR /sui

RUN cargo build --profile release --bin sui-node

# Production Image
FROM debian:bullseye-slim AS runtime
# Use jemalloc as memory allocator
RUN apt-get update && apt-get install -y libjemalloc-dev ca-certificates curl
ENV LD_PRELOAD /usr/lib/x86_64-linux-gnu/libjemalloc.so
ARG PROFILE=release
WORKDIR /sui
# Both bench and release profiles copy from release dir
COPY --from=builder /sui/target/release/sui-node /opt/sui/bin/sui-node
# Support legacy usages of /usr/local/bin/sui-node
COPY --from=builder /sui/target/release/sui-node /usr/local/bin
COPY fullnode.yaml fullnode.yaml


ENTRYPOINT ["/opt/sui/bin/sui-node", "--config-path", "fullnode.yaml"]