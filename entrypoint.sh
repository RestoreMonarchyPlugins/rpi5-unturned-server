#!/bin/bash

cd /opt/steamcmd

# If the .validate file exists, validate the server files
if [ -f /opt/U3DS/.validate ]; then
   rm /opt/U3DS/.validate
   ./steamcmd.sh +force_install_dir /opt/U3DS +login anonymous +app_update 1110390 validate +quit
else
   ./steamcmd.sh +force_install_dir /opt/U3DS +login anonymous +app_update 1110390 +quit
fi

mkdir -p /opt/U3DS/.steam/sdk32
mkdir -p /opt/U3DS/.steam/sdk64
cp linux32/steamclient.so /opt/U3DS/.steam/sdk32/
cp linux64/steamclient.so /opt/U3DS/.steam/sdk64/

cd /opt/U3DS
mkdir -p Unturned_Headless_Data/Plugins/x86_64/
ln -sf ../.steam/sdk64/steamclient.so Unturned_Headless_Data/Plugins/x86_64/steamclient.so

if [ ! -f start.sh ]; then
    cp /opt/unturned-config/start.sh ./start.sh
    chmod +x start.sh
fi

export LD_LIBRARY_PATH="./Unturned_Headless_Data/Plugins/x86_64/"
exec ./start.sh
