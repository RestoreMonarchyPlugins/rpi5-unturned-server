FROM ubuntu:24.04
LABEL com.docker.image.architecture=arm64

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gpg \
    && rm -rf /var/lib/apt/lists/*

# Install box64
RUN wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
    && wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --no-tty --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg \
    && apt-get update && apt-get install -y box64 \
    && rm -rf /var/lib/apt/lists/*

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
