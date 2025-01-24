FROM arm64v8/debian:bookworm
LABEL com.docker.image.architecture=arm64

ENV DEBIAN_FRONTEND=noninteractive
ENV USER steam
ENV STEAMCMDDIR "/opt/steamcmd"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/lib/arm-linux-gnueabihf:/lib/arm-linux-gnueabihf"

RUN dpkg --add-architecture armhf && \
    apt-get update && apt-get install -y \
    wget curl gpg ca-certificates \
    libcurl4 libc6 libstdc++6 \
    libc6:armhf libstdc++6:armhf \
    gcc-arm-linux-gnueabihf libc6-dev:armhf \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list && \
    wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg && \
    wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list && \
    wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg && \
    apt-get update && \
    apt-get install -y box86-generic-arm box64-rpi5arm64 && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m ${USER} && \
    mkdir -p ${STEAMCMDDIR} && \
    chown -R ${USER}:${USER} ${STEAMCMDDIR}

WORKDIR ${STEAMCMDDIR}

USER ${USER}
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - && \
    mkdir -p ~/.steam/sdk64 ~/.steam/sdk32

USER root
RUN mkdir -p /opt/unturned-config /opt/U3DS && \
    ln -s /usr/lib/arm-linux-gnueabihf/libc.so.6 /lib/libc.so.6

COPY entrypoint.sh /entrypoint.sh
COPY start.sh /opt/unturned-config/start.sh
RUN chmod +x /entrypoint.sh /opt/unturned-config/start.sh && \
    chown -R ${USER}:${USER} /opt/U3DS /opt/unturned-config

USER ${USER}
ENTRYPOINT ["/entrypoint.sh"]