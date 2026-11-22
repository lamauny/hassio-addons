# Home Assistant Add-on: Kodi Headless

![Project Stage][project-stage-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports aarch64 Architecture][aarch64-shield]

[Kodi](https://kodi.tv/) Home Assistant add-on.

## About

Runs [Kodi](https://kodi.tv/) with web+ingress interface. 
This addon is based on the docker [image](https://github.com/matthuisman/docker-kodi-headless) from matthuisman

## Notes
- Ingress interface is broken (images not correctly displayed), instead use [hass_ingress](https://github.com/lovelylain/hass_ingress) and configure ingress on localhost:8080
- If necessary, enable proxy support in web interface settings.

---

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[license-shield]: https://img.shields.io/github/license/hassio-addons/addon-example.svg
[maintenance-shield]: https://img.shields.io/maintenance/yes/2023.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-stable-lightgray.svg
[reddit]: https://reddit.com/r/homeassistant
[repository]: https://github.com/lamauny/hassio-addons
