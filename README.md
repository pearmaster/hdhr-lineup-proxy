# hdhr-lineup-proxy

Docker recipe for a proxy to api.hdhomerun.com with the ability to override the lineup.

The old **HDHR3-US DUAL** device stores its channel lineup on the hdhomerun servers at:
```
http://api.hdhomerun.com/api/lineup?DeviceAuth={DEVICE_AUTH}
```

(Note: it used to be ipv4-api.hdhomerun.com)

The lineup is created and uploaded when using the Windows application.  If you're no longer using the Windows application, you can't refresh the file on the hdhomerun.com servers, which can leave your channel list old and outdated.

This is consequential if you're using Emby (or possibly other DVR software like Plex or JellyFin) which will only load the outdated lineup fine.

Instead, if you run this on the same server as your DVR software (and configure it as shown below) then you can load an updateable lineup instead.

## Installation

There are at least two steps:
1. Run the docker image.
2. Modify `/etc/hosts` to load lineup from docker


### Starting docker container

Most basically, you can start the container like this:
```sh
docker run -d -e HDHR_IP_ADDR=${IP_ADDR_TO_HDHR_DEVICE} --name hdhr-lineup-proxy pearmaster/hdhr-lineup-proxy
```

On startup, it will connect to your HDHomerun Device and scan for channels, saving the channel list and providing it over HTTP. 

### Configure DNS

The next step is to convince your computer (the one running DVR software) that it needs to load the lineup from docker instead of the hdhomerun.com servers.  

#### Find IP address of Docker container

You need to determine the IP address of the container.  This command will show it to you:
```sh
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' hdhr-lineup-proxy
```
The result should be something like: `172.17.0.3`

#### Modify `/etc/hosts`

You need to modify the `/etc/hosts` file on the system that is trying to obtain the lineup information from the server.

Add this line, where the provided IP address it the IP address of your docker container:
```
172.17.0.3   api.hdhomerun.com
172.17.0.3   ipv4-api.hdhomerun.com # May be needed if your HDHR3 firmware is old.
```

## How it works

Your HDHR client, like [Emby](https://emby.media), will get `172.17.0.3` as the IP address for ipv4-api.hdhomerun.com instead of the actual public IP address.  Emby will then ask the docker image for the lineup.json file, and will receive any modifications you've made to the file.

It is a little bit like a man-in-the-middle hack.

## License

Apache License.