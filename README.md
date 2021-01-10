# hdhr-lineup-proxy
Docker recipe for a proxy to ipv4-api.hdhomerun.com with override of lineup

I'm not sure exactly how it all works, but the old **HDHR3-US DUAL** device stores its channel lineup on the hdhomerun servers at:
```
http://ipv4-api.hdhomerun.com/api/lineup?DeviceAuth=${DEVICE_AUTH}
```

I think the way this gets created is by using a Windows App.  But editing this is hard for people like me who always use Linux.    So I created this docker image which proxies content from ipv4-api.hdhomerun.com except it caches and allows for modifications to a lineup.json file.

## Installation

### Starting docker container

You should create a directory that can be shared between the host and the container.  In this directory should be created a `lineup.json` file that can be edited.  In the example below, I'm using `/tmp/hdhr`.

Start the container like this:
```sh
docker run -d -e HDHR_IP_ADDR=<IP_ADDR_TO_HDHR_DEVICE> -v /tmp/hdhr:/data --name hdhr-lineup-proxy pearmaster/hdhr-lineup-proxy
```

### Modifying `lineup.json`

If a copy of `lineup.json` doesn't exist on container startup, it will attempt to download it to `/data/lineup.json` in the container (which you should have mapped to a directory on the host; see above).  Any modifications you make to this file will be served instead of the version fro the hdhomerun.com servers.

### Container's IP address

You need to determine the IP address of the container.  This command will show it to you:
```sh
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' hdhr-lineup-proxy
```
The result should be something like: `172.17.0.3`

### DNS

You need to modify the `/etc/hosts` file on the system that is trying to obtain the lineup information from the server.

Add this line, where the provided IP address it the IP address of your docker container:
```
172.17.0.3   ipv4-api.hdhomerun.com
```

## How it works

Your HDHR client, like [Emby](https://emby.media), will get `172.17.0.3` as the IP address for ipv4-api.hdhomerun.com instead of the actual public IP address.  Emby will then ask the docker image for the lineup.json file, and will receive any modifications you've made to the file.

It is a little bit like a man-in-the-middle hack.
