ARG JAVA_VERSION="21.0.10.fx-zulu"

FROM node:trixie-slim AS base-installer

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        bash \
        terminfo \
        ncurses-term \
        unzip \
        zip \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g @google/gemini-cli

RUN useradd -m -s /bin/bash gemini
USER gemini
WORKDIR /home/gemini

RUN curl -fsSL "https://get.sdkman.io?ci=true&rcupdate=false" | bash


FROM base-installer AS final
ARG JAVA_VERSION

USER gemini

ENV SDKMAN_DIR="/home/gemini/.sdkman"
RUN bash -c 'source "${SDKMAN_DIR}/bin/sdkman-init.sh" && sdk install java "${JAVA_VERSION}"'

ENV JAVA_HOME="${SDKMAN_DIR}/candidates/java/current"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

ENTRYPOINT ["gemini"]
