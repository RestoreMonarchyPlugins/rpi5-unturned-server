#!/bin/bash
set -e
cd "${STEAMCMDDIR}"

printf "Unturned Arm Server v0.1\n"
printf "Starting SteamCMD\n"

# Download Updates
if [[ "$STEAMAPPVALIDATE" -eq 1 ]]; then
    VALIDATE="validate"
fi

eval bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
    +login anonymous \
    +app_update "${STEAMAPPID}" "${VALIDATE}" \
    +quit

# Setup Steam client
mkdir -p "${STEAMAPPDIR}"/.steam/sdk64
ln -sfT "${STEAMCMDDIR}"/linux64/steamclient.so "${STEAMAPPDIR}"/.steam/sdk64/steamclient.so

# Setup Rocket mod
if [ ! -f "${STEAMAPPDIR}"/.vanilla ] && [ -d "${STEAMAPPDIR}"/Extras/Rocket.Unturned ]; then
    mkdir -p "${STEAMAPPDIR}"/Modules
    cp -r "${STEAMAPPDIR}"/Extras/Rocket.Unturned "${STEAMAPPDIR}"/Modules/
    printf "Rocket mod installed\n"
fi

# Setup plugins directory
mkdir -p "${STEAMAPPDIR}"/Unturned_Headless_Data/Plugins/x86_64/
ln -sf "${STEAMAPPDIR}"/.steam/sdk64/steamclient.so "${STEAMAPPDIR}"/Unturned_Headless_Data/Plugins/x86_64/steamclient.so

# Copy start script if not exists
if [ ! -f "${STEAMAPPDIR}"/start.sh ]; then
    cp /opt/unturned-config/start.sh "${STEAMAPPDIR}"/start.sh
    chmod +x "${STEAMAPPDIR}"/start.sh
fi

cd "${STEAMAPPDIR}"
export LD_LIBRARY_PATH="./Unturned_Headless_Data/Plugins/x86_64/:${LD_LIBRARY_PATH}"
exec box64 ./start.sh