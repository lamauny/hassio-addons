ARG BUILD_ARCH
ARG BUILD_VERSION=latest
FROM ghcr.io/music-assistant/server:${BUILD_VERSION}

RUN apt-get update && apt-get install patch && \
    rm -rf /var/lib/apt/lists/*

# Add files.
COPY rootfs/ /

# Patch !
RUN cd / && \
    for p in /patches/*.patch; do patch -p0 < "$p"; done

# Labels
LABEL \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.version=${BUILD_VERSION}
