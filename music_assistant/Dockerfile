ARG BUILD_ARCH
ARG BUILD_VERSION=latest
FROM ghcr.io/music-assistant/server:${BUILD_VERSION}

# Add files.
COPY rootfs/ /

# move providers
RUN cd / && \
    mv -rf /providers $(python3 -c 'import sysconfig; print(sysconfig.get_paths()["purelib"])')/music_assistant/

# Labels
LABEL \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.version=${BUILD_VERSION}
