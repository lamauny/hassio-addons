ARG BUILD_ARCH
ARG BUILD_VERSION=latest
FROM ghcr.io/music-assistant/server:${BUILD_VERSION}

# Add files.
COPY rootfs/ /

# move providers
RUN SITE="$(python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')" && \
    cp -a /providers/. $SITE/music_assistant/providers/ && \
    rm -rf /providers

# Labels
LABEL \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.version=${BUILD_VERSION}
