FROM ghcr.io/music-assistant/server:latest

RUN apt-get update && apt-get install patch && \
    rm -rf /var/lib/apt/lists/*

# Add files.
COPY rootfs/ /

# Patch !
RUN cd / && \
    for p in /patches/*.patch; do patch -p0 < "$p"; done
