#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

####################
# LIST LOCAL DISKS #
####################

function list_drives () {
    bashio::log.info "List of available labels (@dianlight)"
    bashio::log.blue "---------------------------------------------------"
    #autodisks=($(lsblk -E label -n -o label | sed -r '/^\s*$/d' | grep -v hassos | grep pp))
    readarray -t autodisks < <(lsblk -E label -n -o label -i | sed -r '/^\s*$/d' | grep -v hassos)
    if [ ${#autodisks[@]} -eq 0 ]; then
        bashio::log.info "No Disk with labels."
    else
        bashio::log.info "Available Disk Labels:"
        # shellcheck disable=SC2068
        for disk in ${autodisks[@]}; do
            # shellcheck disable=SC2046
            bashio::log.info "\t${disk}[$(lsblk $(blkid -L "$disk") -no fstype)]"
        done
    fi
    bashio::log.blue "---------------------------------------------------"
}

######################
# MOUNT LOCAL SHARES #
######################

# Mount local Share if configured
if bashio::config.has_value 'localdisks'; then

    MOREDISKS=$(bashio::config 'localdisks')
    echo "Local Disks mounting..."

    # Separate comma separated values
    # shellcheck disable=SC2086
    for disk in ${MOREDISKS//,/ }; do

        # Mount by device as default
        devpath=/dev

        # Mount as uuid
        if [ ${#disk} == 36 ] ; then
            devpath=/dev/disk/by-uuid
            # Mount as label
        elif [ "${disk:0:2}" != "sd" ] && [ "${disk:0:4}" != "nvme" ] ; then
            devpath=/dev/disk/by-label
        fi

        # Creates dir
        mkdir -p /mnt/"$disk"
        if bashio::config.has_value 'PUID' && bashio::config.has_value 'PGID'; then
            PUID="$(bashio::config 'PUID')"
            PGID="$(bashio::config 'PGID')"
            chown "$PUID:$PGID" /mnt/"$disk"
        fi

        # Install lsblk
        if ! command -v "lsblk" &>/dev/null; then
            if command -v "apk" &>/dev/null; then apk add --no-cache lsblk >/dev/null; fi
            if command -v "apt" &>/dev/null; then apt-get update && apt-get install -yqq util-linux; fi
        fi

        # Check FS type and set relative options (thanks @https://github.com/dianlight/hassio-addons)
        fstype=$(lsblk "$devpath"/"$disk" -no fstype)
        options="nosuid,relatime,noexec"
        type="auto"
        bashio::log.info "Mounting ${disk} of type ${fstype}"

        case "$fstype" in
            exfat | vfat | msdos)
                bashio::log.warning "${fstype} permissions and ACL don't works and this is an EXPERIMENTAL support"
                options="${options},umask=000"
                ;;
            ntfs)
                bashio::log.warning "${fstype} is an EXPERIMENTAL support"
                options="${options},umask=000"
                type="ntfs"
                ;;
            *)
                if bashio::config.has_value 'PUID' && bashio::config.has_value 'PGID'; then
                    echo "Using PUID $(bashio::config 'PUID') and PGID $(bashio::config 'PGID')"
                    options="$options,uid=$(bashio::config 'PUID'),gid=$(bashio::config 'PGID')"
                fi
                ;;
        esac

        # Legacy mounting : mount to share if still exists (avoid breaking changes)
        dirpath="/mnt"
        if [ -d /share/"$disk" ]; then dirpath="/share"; fi

        # shellcheck disable=SC2015
        mount -t $type "$devpath"/"$disk" "$dirpath"/"$disk" -o $options && bashio::log.info "Success! $disk mounted to /mnt/$disk" || \
            (bashio::log.fatal "Unable to mount local drives! Please check the name."
            rmdir /mnt/$disk
            list_drives
        bashio::addon.stop)
    done

fi
