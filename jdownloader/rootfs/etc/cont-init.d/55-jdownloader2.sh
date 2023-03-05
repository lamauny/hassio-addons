#!/command/with-contenv sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Make sure mandatory directories exist.
mkdir -p /config/jd/logs

# Set default configuration on new install.
if [ ! -f /config/jd/JDownloader.jar ]; then
    cp /defaults/JDownloader.jar /config/jd/
    cp -r /defaults/cfg /config/jd/
fi

# Set MyJDownloader credentials.
if [ -n "${MYJDOWNLOADER_EMAIL:-}" ] && [ -n "${MYJDOWNLOADER_PASSWORD:-}" ]
then
    jq -c -M ".email=\"$MYJDOWNLOADER_EMAIL\" | .password = \"$(echo "$MYJDOWNLOADER_PASSWORD" | sed 's/"/\\"/g')\"" /config/jd/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json | sponge /config/jd/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
fi

# Set the MyJDownloader device name.
if [ -n "${MYJDOWNLOADER_DEVICE_NAME:-}" ]; then
    jq -c -M ".devicename = \"$(echo "$MYJDOWNLOADER_DEVICE_NAME" | sed 's/"/\\"/g')\"" /config/jd/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json | sponge /config/jd/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json
fi

# Handle dark mode change.
if is-bool-val-false "${DARK_MODE:-0}"; then
    # Dark mode disabled.  Change theme only if it is currently set to our dark mode.
    CURRENT_THEME="$(jq -r -c -M '.lookandfeeltheme' /config/jd/cfg/org.jdownloader.settings.GraphicalUserInterfaceSettings.json)"
    if [ "$CURRENT_THEME" = "FLATLAF_DRACULA" ]; then
        jq -c -M '.lookandfeeltheme = "DEFAULT"' /config/jd/cfg/org.jdownloader.settings.GraphicalUserInterfaceSettings.json | sponge /config/jd/cfg/org.jdownloader.settings.GraphicalUserInterfaceSettings.json
    fi
else
    # Dark mode enabled.  Force theme.
    jq -c -M '.lookandfeeltheme = "FLATLAF_DRACULA"' /config/jd/cfg/org.jdownloader.settings.GraphicalUserInterfaceSettings.json | sponge /config/jd/cfg/org.jdownloader.settings.GraphicalUserInterfaceSettings.json
fi

# Take ownership of the output directory.
# take-ownership --not-recursive /output

# vim: set ft=sh :
