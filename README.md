# Unturned ARM Server
Docker image for running Unturned Dedicated Server on ARM devices (Raspberry Pi)

## Usage
```sh
docker run -d \
 --name unturned \
 -p 27115:27115 \
 -v ./U3DS:/opt/U3DS \
 ghcr.io/restoremonarchyplugins/unturned-arm-server:latest
```

## Other features
- The server will automatically update on restart if there is a new version available
- To validate the server files, create `.validate`in U3DS folder. For example using `touch U3DS/.validate` 
