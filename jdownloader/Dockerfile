#
# jdownloader-2 Dockerfile
#
# Pull base image.
ARG BUILD_FROM
FROM $BUILD_FROM

# Define software download URLs.
ARG JDOWNLOADER_URL=http://installer.jdownloader.org/JDownloader.jar

# Download JDownloader2
RUN \
    apk --no-cache add wget && \
    mkdir -p /defaults && \
    wget -O /defaults/JDownloader.jar ${JDOWNLOADER_URL} && \
    apk del wget --purge

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN \
    apk --no-cache add \
        java-common \
        openjdk8-jre \
        # Needed by the init script.
        jq \
        # We need a font.
        ttf-dejavu \
        # For ffmpeg and ffprobe tools.
        ffmpeg \
        # For rtmpdump tool.
        rtmpdump \
        # Need for the sponge tool.
        moreutils

# Add files.
COPY rootfs/ /

# Copy helpers.
COPY helpers/* /usr/bin/

# Define mountable directories.
VOLUME ["/output"]

# Expose ports.
#   - 3129: For MyJDownloader in Direct Connection mode.
EXPOSE 3129

# Metadata.
LABEL \
    maintainer="Lamauny <lamauny@users.noreply.github.com>"
