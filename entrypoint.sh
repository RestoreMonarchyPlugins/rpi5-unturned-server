#!/bin/bash
set -e
cd ${STEAMCMDDIR}
printf "Unturned Arm Server v0.1\n"
printf "Starting SteamCMD\n"

# Initialize SteamCMD using bash directly
bash ./steamcmd.sh +quit
printf "SteamCMD finished\n"

if [ -f /opt/U3DS/.validate ]; then
    rm /opt/U3DS/.validate
    printf "Validating Unturned server\n"
    bash ./steamcmd.sh +force_install_dir /opt/U3DS +login anonymous +app_update 1110390 validate +quit
else
    printf "Updating Unturned server\n"
    bash ./steamcmd.sh +force_install_dir /opt/U3DS +login anonymous +app_update 1110390 +quit
fi

# Setup Rocket mod if not vanilla
if [ ! -f /opt/U3DS/.vanilla ] && [ -d /opt/U3DS/Extras/Rocket.Unturned ]; then
    mkdir -p /opt/U3DS/Modules
    cp -r /opt/U3DS/Extras/Rocket.Unturned /opt/U3DS/Modules/
    printf "Rocket mod installed\n"
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
    printf "Start script copied\n"
fi

export LD_LIBRARY_PATH="./Unturned_Headless_Data/Plugins/x86_64/:${LD_LIBRARY_PATH}"
exec box64 ./start.sh