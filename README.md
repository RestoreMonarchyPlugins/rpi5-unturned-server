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
and add the following line to the file, after `Include /etc/ssh/sshd_config.d/*.conf` line

```
PermitRootLogin yes
```
![image](https://github.com/user-attachments/assets/e501f641-8f80-40af-840f-b20e62bb9854)

Then restart the ssh service
```sh
sudo systemctl restart ssh
```

Now you can log in as root.

## Changing Kernel Page Size
SteamCMD requires a kernel page size of 4KB.  
To check the current page size run the following command
```sh
getconf PAGESIZE
```

If the page size is not 4KB (4096), but for example 16KB, you will need to change it by editing the boot configuration file
```sh
nano /boot/firmware/config.txt
```

Add the following line to the file
```sh
kernel=kernel8.img
```
![image](https://github.com/user-attachments/assets/42199015-c340-40e9-a502-5cc62aa07d2c)


Then reboot the device
```sh
reboot
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

## Box64 Installation
Download Box64 repository
```sh
wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list
```
Add Box64 repository
```sh
wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg
```
Update packages
```sh
apt update
```
Install Box64
```sh
apt install box64
```

## Unturned Server Installation
First pull the latest version of the image
```sh
docker pull ghcr.io/restoremonarchyplugins/rpi5-unturned-server:latest
```
Then run the following command to create and start the server. This will create a new container named `unturned` and create a volume named `U3DS` in the current directory. The port `27115` is used for Rocket RCON. To join the server you will need to use Server Code.
```sh
docker run -d \
 --name unturned \
 -p 27115:27115 \
 -v ./U3DS:/opt/U3DS \
 ghcr.io/restoremonarchyplugins/rpi5-unturned-server:latest
```

## Other features
- The server will automatically update on restart if there is a new version available
- To validate the server files, create `.validate` in U3DS folder. `touch U3DS/.validate`
- To disable RocketMod, create `.vanilla` in U3DS folder. `touch U3DS/.vanilla`
