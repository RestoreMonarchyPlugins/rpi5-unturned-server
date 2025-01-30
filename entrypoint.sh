#!/bin/bash
cd /opt/steamcmd

if [ -f /opt/U3DS/.validate ]; then
   rm /opt/U3DS/.validate
   ./steamcmd.sh +force_install_dir /opt/U3DS +login anonymous +app_update 1110390 validate +quit
else
   ./steamcmd.sh +force_install_dir /opt/U3DS +login anonymous +app_update 1110390 +quit
fi

if [ -f /opt/U3DS/.vanilla ]; then
   rm -rf /opt/U3DS/Modules/Rocket.Unturned
else
   cp -r /opt/U3DS/Extras/Rocket.Unturned /opt/U3DS/Modules/
fi

mkdir -p /opt/U3DS/.steam/sdk64
cp linux64/steamclient.so /opt/U3DS/.steam/sdk64/
cd /opt/U3DS
mkdir -p Unturned_Headless_Data/Plugins/x86_64/
ln -sf ../.steam/sdk64/steamclient.so Unturned_Headless_Data/Plugins/x86_64/steamclient.so

if [ ! -f start.sh ]; then
    cp /opt/unturned-config/start.sh ./start.sh
    chmod +x start.sh
fi

export LD_LIBRARY_PATH="./Unturned_Headless_Data/Plugins/x86_64/"
exec box64 ./start.sh