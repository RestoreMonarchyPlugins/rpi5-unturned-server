# Unturned ARM Server
Docker image for running Unturned Dedicated Server on ARM devices (Raspberry Pi)

## Usage
```bash
docker run -d \
 --name unturned \
 -p 27115:27115 \
 -v ./U3DS:/opt/U3DS \
 ghcr.io/restoremonarchyplugins/unturned-arm-server:latest
```
