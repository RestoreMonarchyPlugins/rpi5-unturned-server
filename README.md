# Unturned ARM Server
Docker image for running Unturned Dedicated Server on ARM devices (Raspberry Pi 5)

## Enabling Root User
Set the password for the root user using this command:
```sh
sudo passwd root
```
Then enable remote connections to root user, open `sshd_config` file
```sh
sudo nano /etc/ssh/sshd_config
```
and add the following line to the file
```
PermitRootLogin yes
```

Then restart the ssh service
```sh
sudo systemctl restart ssh
```

## Docker Installation
Login as root user and run the following command to install Docker
```sh
curl -sSL https://get.docker.com/ | CHANNEL=stable bash
```
Then enable and start the Docker service
```sh
systemctl enable --now docker
```

## Unturned Server Installation
First pull the latest version of the image
```sh
docker pull ghcr.io/restoremonarchyplugins/unturned-arm-server:latest
```
Then run the following command to create and start the server. This will create a new container named `unturned` and create a volume named `U3DS` in the current directory. The port `27115` is used for Rocket RCON. To join the server you will need to use Server Code.
```sh
docker run -d \
 --name unturned \
 -p 27115:27115 \
 -v ./U3DS:/opt/U3DS \
 ghcr.io/restoremonarchyplugins/unturned-arm-server:latest
```

## Other features
- The server will automatically update on restart if there is a new version available
- To validate the server files, create `.validate` in U3DS folder. `touch U3DS/.validate`
- To disable RocketMod, create `.vanilla` in U3DS folder. `touch U3DS/.vanilla`
