FROM ubuntu:18.04

USER root

# Install dependencies.
RUN apt-get update -y && apt-get install -y build-essential cmake curl git python cargo

# Create a regular user.
RUN useradd -m rustacean

# Copy the code over, create an empty directory for builds.
ADD . /code
# RUN cd /code
RUN mkdir /build && cd /build

# Generate Makefile using settings suitable for an experimental compiler
RUN /code/configure \
    --enable-debug \
    --disable-docs \
    --enable-llvm-assertions \
    --enable-debug-assertions \
    --enable-optimize \
    --enable-llvm-release-debuginfo \
    --experimental-targets=AVR

RUN make
RUN make install

# Symlink the LLVM build directory to /build/llvm
RUN ln -sf /build/x86_64-unknown-linux-gnu/llvm/ /build/llvm

# Drop down to the regular user
USER rustacean

RUN cargo install xargo
ENV XARGO_RUST_SRC="/code/src"

ENV PATH="/home/rustacean/.cargo/bin:${PATH}"

VOLUME /code

