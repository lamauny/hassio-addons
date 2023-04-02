# syntax=docker/dockerfile:1
#
# pyLoad Dockerfile
#
# Pull base image.
ARG BUILD_FROM
FROM $BUILD_FROM

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PYLOAD_VERSION
LABEL build_version="Lamauny version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Lamauny <lamauny@users.noreply.github.com>"

ENV HOME="/config/addons_config/pyload"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    build-base \
    cargo \
    curl-dev \
    libffi-dev \
    libjpeg-turbo-dev \
    openssl-dev \
    python3-dev \
    zlib-dev
RUN \
  echo "**** install packages ****" && \
  apk add --no-cache \
    ffmpeg \
    libjpeg-turbo \
    p7zip \
    python3 \
    sqlite \
    tesseract-ocr
RUN \
  echo "**** install pyload ****" && \
  if [ -z ${PYLOAD_VERSION+x} ]; then \
    PYLOAD_VERSION=$(curl -sL  https://pypi.python.org/pypi/pyload-ng/json |jq -r '. | .info.version'); \
  fi && \
  python3 -m ensurepip && \
  pip3 install -U --no-cache-dir \
    pip \
    wheel && \
  pip3 install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.17/ \
    pyload-ng[all]=="${PYLOAD_VERSION}"
RUN \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/* \
    ${HOME}/.cache \
    ${HOME}/.cargo

# add local files
COPY root/ /

# Copy helpers.
COPY helpers/* /usr/bin/

# ports and volumes
EXPOSE 8000 9666
VOLUME /config
