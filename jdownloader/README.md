# Home Assistant Add-on: [jdownloader](https://jdownloader.org/)

## Introduction

JDownloader is a free, open-source download management tool with a huge community that makes downloading as easy and fast as it should be. Users can start, stop or pause downloads, set bandwith limitations, auto-extract archives and much more. It's an easy-to-extend framework that can save hours of your valuable time every day!

This Add-on runs jdownloader as docker container with MyJDownloader UI compatible interface.

## Installation

To install this Hass.io add-on you need to add the Lamauny add-on repository
first:

You can do this by navigating to the "Add-on Store" tab in the Supervisor panel and then entering https://github.com/lamauny/hassio-addons in the "Add new repository by URL" field.

Press install to download the add-on and unpack it on your machine. This can take some time.

Start the add-on, check the logs of the add-on to see if everything went well.

On first start-up, a new configuration is created. This can take some time.
Please be patient. 

## Configuation

Example add-on configuration:

```
 {
    "user": "user@email.com",
    "passwd": "password",
    "config": "Jdownloader/cfg",
    "extensions": "Jdownloader/ext",
    "downloads": "Jdownloader/Downloads",
 }
```

### Option: `user`

MyJDownloader user login

### Option: `passwd`

MyJDownloader user password

### Option: `config`

Config folder

### Option: `extensions`

extensions folder

### Option: `downloads`

Downloads folder

