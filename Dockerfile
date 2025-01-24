FROM ghcr.io/sonroyaalmerol/steamcmd-arm64:root

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/box64-x86_64-linux-gnu"
ENV USER=steam
ENV HOMEDIR="/home/${USER}"
ENV STEAMCMDDIR="${HOMEDIR}/steamcmd"

# Create directories and set permissions
RUN mkdir -p /opt/U3DS /opt/unturned-config && \
    chown -R ${USER}:${USER} /opt/U3DS /opt/unturned-config

# Copy scripts
COPY entrypoint.sh /opt/
COPY start.sh /opt/unturned-config/start.sh
RUN chmod +x /opt/entrypoint.sh /opt/unturned-config/start.sh

# Set Box64 optimizations
ENV BOX64_DYNAREC_BIGBLOCK=0
ENV BOX64_DYNAREC_SAFEFLAGS=2
ENV BOX64_DYNAREC_STRONGMEM=3
ENV BOX64_DYNAREC_X87DOUBLE=1

USER ${USER}
WORKDIR ${STEAMCMDDIR}

ENTRYPOINT ["/opt/entrypoint.sh"]