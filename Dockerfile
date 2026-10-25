FROM ubuntu:22.04@sha256:0a9887931b0e38af2e3487ed39e29436b0535c4f3f52e57745baaf79d1898956 AS payload
COPY release.tar.gz /tmp/release.tar.gz
RUN echo '8ad2706c9fb28abd2466977e172d3115d4c91b96333c69550a9e09f18422f6aa  /tmp/release.tar.gz' | sha256sum -c -  && mkdir /release  && tar -xzf /tmp/release.tar.gz --strip-components=1 -C /release  && cd /release && sha256sum -c PACKAGE-SHA256SUMS

FROM ubuntu:22.04@sha256:0a9887931b0e38af2e3487ed39e29436b0535c4f3f52e57745baaf79d1898956
LABEL org.opencontainers.image.title="Rogue Network node"  org.opencontainers.image.version="4.1.0"  org.opencontainers.image.revision="4bd6206e1bf07290bc028285858dff87d8c8488f51dc423e9f6d7ef05adb435d"  org.opencontainers.image.source="https://github.com/rogueisles/Rogue-Network"  org.opencontainers.image.description="FORGE V5 activation at RGN block 1121800; optional SOQ and bounded registry"
RUN apt-get update && apt-get install -y --no-install-recommends python3 ca-certificates  && rm -rf /var/lib/apt/lists/*  && groupadd --gid 10001 rgn  && useradd --uid 10001 --gid 10001 --home-dir /var/lib/rgn --no-create-home --shell /usr/sbin/nologin rgn  && mkdir -p /var/lib/rgn && chown 10001:10001 /var/lib/rgn
COPY --from=payload /release/ /opt/rgn/
COPY entrypoint.py health.py /opt/rgn/docker/
ENV RGN_DATADIR=/var/lib/rgn RGN_CACHE_MB=512 RGN_MAX_PEERS=25 RGN_P2P_PORT=30303 RGN_RPC_PORT=18545
WORKDIR /opt/rgn
VOLUME ["/var/lib/rgn"]
EXPOSE 18545/tcp 30303/tcp 30303/udp
USER 10001:10001
STOPSIGNAL SIGINT
HEALTHCHECK --interval=30s --timeout=15s --start-period=180s --retries=3 CMD ["python3", "/opt/rgn/docker/health.py", "--quiet"]
ENTRYPOINT ["python3", "/opt/rgn/docker/entrypoint.py"]
