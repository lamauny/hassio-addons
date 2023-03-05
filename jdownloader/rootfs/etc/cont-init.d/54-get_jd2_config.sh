#!/command/with-contenv bashio

printf "$(bashio::config 'email')" > /var/run/s6/container_environment/MYJDOWNLOADER_EMAIL
printf "$(bashio::config 'password')" > /var/run/s6/container_environment/MYJDOWNLOADER_PASSWORD
printf "$(bashio::config 'device_name')" > /var/run/s6/container_environment/MYJDOWNLOADER_DEVICE_NAME
printf "true" > /var/run/s6/container_environment/JDOWNLOADER_HEADLESS
