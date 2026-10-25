# Rogue Network Docker 4.1.0

**Required FORGE V5 upgrade before block 1,121,800.** Every validator/exchange must
install the same release/profile; pools must also update their adapter and guards.
The clock estimate is 27 October 2026 around 13:35 UTC. Activation follows block height.

```sh
docker pull roguenetwork/rogue-network:4.1.0
docker volume create rgn-data
docker run -d --name rgn-node --restart unless-stopped --stop-timeout 120 \
  -p 127.0.0.1:18545:18545 -p 30303:30303/tcp -p 30303:30303/udp \
  -v rgn-data:/var/lib/rgn roguenetwork/rogue-network:4.1.0
```

When upgrading, stop the old container gracefully and reuse its existing data
volume. Back up configuration and wallet custody. Do not delete the volume or
chain database. Keep RPC private. Non-root UID/GID 10001; bind mounts must already
be writable by that account. A named volume prepares ownership automatically.

The image pins the binary and approved mainnet profile. Original genesis/history
and per-block rewards remain unchanged. V4 applies below 1,121,800; V5 and its
12.5-second target apply from that height. SOQ is optional mining work and regular
validators do not run native full nodes. WALLET selects a public beneficiary;
it does not launch a complete miner.

```sh
docker logs -f rgn-node
docker exec rgn-node python3 /opt/rgn/docker/health.py
```

The local health check verifies the exact identity/profile and responsiveness.
Also check peer connections, syncing status and height against the network.
`eth_syncing=false` at height zero is not proof of completed synchronization.

Build the same payload image with `docker build -t roguenetwork/rogue-network:4.1.0 .`.
Complete source and source-build Dockerfile:
https://github.com/rogueisles/Rogue-Network
Native binary release:
https://github.com/rogueisles/Rogue-Node/releases/tag/v4.1.0
Pool/operator guide:
https://github.com/rogueisles/Mining-Pool

Read release notes and qualification scope before deployment. After V5 blocks
exist, retain V5 validation; restoring a V4-only image is unsafe.

[Approved activation profile and generated review](config/MAINNET-V5-RELEASE.md).

The 4.1.0 packaging retains the tested node's internal build identifier `rgn400v5`. This identifier is opaque; the release version, scheduled profile and published checksums identify this package.
