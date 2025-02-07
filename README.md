# Unturned Server on Raspberry Pi 5
Docker image for running Unturned Dedicated Server on Raspberry Pi 5

Learn how to set up an Unturned server on Raspberry Pi 5 using this image on our blog article:  
[Hosting an Unturned Server on Raspberry Pi 5](https://restoremonarchy.com/servers/blog/untrpi01)

## Docker Image
Pull the latest image from GitHub Container Registry
```sh
docker pull ghcr.io/restoremonarchyplugins/rpi5-unturned-server:latest
```
Create a container using the following command
```sh
docker run -d \
 --name unturned \
 -p 27115:27115 \
 -v ./U3DS:/opt/U3DS \
 --restart always \
 ghcr.io/restoremonarchyplugins/rpi5-unturned-server:latest
```

## Other features
- The server will automatically update on restart if there is a new version available
- To validate the server files, create `.validate` in U3DS folder. `touch U3DS/.validate`
- To disable RocketMod, create `.vanilla` in U3DS folder. `touch U3DS/.vanilla`
