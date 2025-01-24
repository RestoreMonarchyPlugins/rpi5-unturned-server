FROM ubuntu:24.04
LABEL com.docker.image.architecture=arm64

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gpg \
    && rm -rf /var/lib/apt/lists/*

# Install both box86 and box64
RUN wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list \
    && wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg \
    && wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
    && wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg \
    && apt-get update && apt-get install -y box86 box64 \
    && rm -rf /var/lib/apt/lists/*

ENV BOX86_PATH=/opt/steamcmd/linux32
ENV BOX64_PATH=/opt/steamcmd/linux64

# Setup steamcmd
RUN mkdir -p /opt/steamcmd
WORKDIR /opt/steamcmd
RUN curl -sSL -o steamcmd.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xzvf steamcmd.tar.gz \
    && rm steamcmd.tar.gz

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /opt/unturned-config
COPY start.sh /opt/unturned-config/start.sh
RUN chmod +x /opt/unturned-config/start.sh

ENTRYPOINT ["/entrypoint.sh"]
