FROM ghcr.io/music-assistant/server:latest

RUN apt-get update && apt-get install patch && \
    rm -rf /var/lib/apt/lists/*

COPY deezer.patch /tmp
RUN cd / && patch -p0 < /tmp/deezer.patch
