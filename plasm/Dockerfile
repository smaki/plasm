FROM ubuntu:18.04

ARG PLASM_USER
ARG PLASM_GROUP
ARG NIGHTLY_VER
ARG PLASM_VER

ENV APP_ROOT="/home/plasmnode" \
    PLASM_GROUP="${PLASM_GROUP}" \
    PLASM_USER="${PLASM_USER}" \
    PLASM_VERSION="${PLASM_VER}" \
    NIGHTLY_VERSION="${NIGHTLY_VER}"

RUN apt-get update && \
    apt-get install \
       wget -y;

RUN groupadd --gid $PLASM_USER plasmnode \
  && useradd --uid $PLASM_USER --gid plasmnode --shell /bin/bash --create-home plasmnode

RUN chown -R plasmnode:plasmnode $APP_ROOT

ENV RUSTUP_HOME=/rust
ENV CARGO_HOME=/cargo
ENV PATH=/cargo/bin:/rust/bin:$PATH

RUN \
    cd && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        cmake \
        git \
        clang \
        libclang-dev \
        build-essential \
        bash \
        ca-certificates \
        ssh \
        libssl-dev \
        curl \
        pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*;

RUN echo "(curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $NIGHTLY_VERSION) && rustup default $NIGHTLY_VERSION" > /install-rust.sh && \
    chmod 755 /install-rust.sh && \
    /install-rust.sh;

RUN rustup target add wasm32-unknown-unknown \
        --toolchain $NIGHTLY_VERSION; \
    cargo +$NIGHTLY_VERSION install \
        --git https://github.com/alexcrichton/wasm-gc; \
    cargo +$NIGHTLY_VERSION install \
        --locked --force --git https://github.com/staketechnologies/Plasm --tag $PLASM_VERSION plasm-cli;

RUN rm -rf /tmp/*;

USER plasmnode

WORKDIR $APP_ROOT
EXPOSE 80

#RUN plasm-node --base-path $APP_ROOT/db
ENTRYPOINT bash
#CMD ["plasm-node", "--base-path", "$APP_ROOT/db"]
