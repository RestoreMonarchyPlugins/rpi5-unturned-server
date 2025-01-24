FROM ghcr.io/sonroyaalmerol/steamcmd-arm64:root

ENV STEAMAPPID=1110390
ENV STEAMAPPVALIDATE=1
ENV STEAMAPPDIR=/opt/U3DS
ENV ARM64_DEVICE=rpi5-16k
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/box64-x86_64-linux-gnu"

RUN mkdir -p /opt/U3DS /opt/unturned-config && \
    chown -R steam:steam /opt/U3DS /opt/unturned-config

COPY entrypoint.sh /opt/
COPY start.sh /opt/unturned-config/start.sh
RUN chmod +x /opt/entrypoint.sh /opt/unturned-config/start.sh && \
    chown steam:steam /opt/entrypoint.sh /opt/unturned-config/start.sh

ENV BOX64_DYNAREC_BIGBLOCK=0
ENV BOX64_DYNAREC_SAFEFLAGS=2
ENV BOX64_DYNAREC_STRONGMEM=3
ENV BOX64_DYNAREC_X87DOUBLE=1

USER steam
WORKDIR ${STEAMCMDDIR}

ENTRYPOINT ["/opt/entrypoint.sh"]