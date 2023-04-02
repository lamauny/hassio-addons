#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

PUID=$(bashio::config 'PUID')
PGID=$(bashio::config 'PGID')

PUID=${PUID:-911}
PGID=${PGID:-911}

addgroup -g "$PGID" abc
adduser -G abc -u "$PUID" -D abc
