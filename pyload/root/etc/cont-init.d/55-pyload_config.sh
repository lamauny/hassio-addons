#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

umask 022

export PYTHONPATH=/usr/lib/python3.10/site-packages:/usr/local/lib/python3.10/site-packages
export CONFIG="/config/addons_config/pyload"
export HOME=$CONFIG
export DOWNLOADS="$(bashio::config 'download_dir')"

# create our folders
mkdir -p $CONFIG $HOME $DOWNLOADS

# default config file
cp -n \
    /defaults/pyload.cfg \
    $CONFIG/settings/pyload.cfg

chown -R abc:abc \
    $CONFIG

chown abc:abc \
    $DOWNLOADS
