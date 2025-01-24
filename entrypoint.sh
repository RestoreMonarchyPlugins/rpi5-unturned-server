#!/bin/bash
set -e

cd ${STEAMCMDDIR}

# Initialize SteamCMD
./steamcmd.sh +quit

# Install/Update Unturned Dedicated Server
if [ -f /opt/U3DS/.validate ]; then
    rm /opt/U3DS/.validate
    box64 ${STEAMCMDDIR}/steamcmd.sh +force_install_dir /opt/U3DS +login anonymous +app_update 1110390 validate +quit
else
    box64 ${STEAMCMDDIR}/steamcmd.sh +force_install_dir /opt/U3DS +login anonymous +app_update 1110390 +quit
fi

# Setup Rocket mod if not vanilla
if [ ! -f /opt/U3DS/.vanilla ] && [ -d /opt/U3DS/Extras/Rocket.Unturned ]; then
    mkdir -p /opt/U3DS/Modules
    cp -r /opt/U3DS/Extras/Rocket.Unturned /opt/U3DS/Modules/
fi

# Setup Steam client
mkdir -p /opt/U3DS/.steam/sdk64
cp ${STEAMCMDDIR}/linux64/steamclient.so /opt/U3DS/.steam/sdk64/
cd /opt/U3DS
mkdir -p Unturned_Headless_Data/Plugins/x86_64/
ln -sf ../.steam/sdk64/steamclient.so Unturned_Headless_Data/Plugins/x86_64/steamclient.so

# Copy start script if not exists
if [ ! -f start.sh ]; then
    cp /opt/unturned-config/start.sh ./start.sh
    chmod +x start.sh
fi

export LD_LIBRARY_PATH="./Unturned_Headless_Data/Plugins/x86_64/:${LD_LIBRARY_PATH}"
exec box64 ./start.sh