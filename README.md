# Rogue Network Docker Node

RGN full node for Linux AMD64, with persistent storage and a bundled mainnet profile.

**FORGE V5 activates at block 1,121,800 — estimated 27 October 2026, 13:35 UTC.**

All RGN nodes, including exchange nodes, must upgrade before block **1,121,800**.

## Fresh installation

```sh
docker pull roguenetwork/rogue-network:4.1.0
docker volume create rgn-data
docker run -d --name rgn-node --restart unless-stopped --stop-timeout 120 \
  -p 127.0.0.1:18545:18545 -p 30303:30303/tcp -p 30303:30303/udp \
  -v rgn-data:/var/lib/rgn roguenetwork/rogue-network:4.1.0
```

## Upgrade an existing container

Reuse the existing volume or bind mount and retain custom environment settings.
This example uses the container `rgn-node` and volume `rgn-data`:

```sh
docker pull roguenetwork/rogue-network:4.1.0
docker stop -t 120 rgn-node
docker rm rgn-node
docker run -d --name rgn-node --restart unless-stopped --stop-timeout 120 \
  -p 127.0.0.1:18545:18545 -p 30303:30303/tcp -p 30303:30303/udp \
  -v rgn-data:/var/lib/rgn roguenetwork/rogue-network:4.1.0
```

The data volume is preserved when the container is replaced. Keep RPC bound to
localhost unless protected access is configured.

## Check the node

```sh
docker logs -f rgn-node
docker exec rgn-node python3 /opt/rgn/docker/health.py
```

Confirm connected peers and continuing chain progress after startup.

## Configuration

| Setting | Default |
| --- | --- |
| Data directory | `/var/lib/rgn` |
| Container user | UID/GID `10001:10001` |
| RPC port | `18545` |
| P2P port | `30303` TCP/UDP |
| `RGN_CACHE_MB` | `512` |
| `RGN_MAX_PEERS` | `25` |

Named volumes are initialized for the container user. Prepare bind-mount
ownership for UID/GID 10001 before starting the container.

Immutable image reference:

```text
roguenetwork/rogue-network@sha256:a992e0a5cc5de1474c92e0bfb006dfdcd024ab98a4ee9c3d5f675a978e6ef97f
```

## Build this context

```sh
git clone --branch v4.1.0 https://github.com/rogueisles/Rogue-Docker-Node.git
cd Rogue-Docker-Node
docker build -t roguenetwork/rogue-network:4.1.0 .
```

For a build from the complete node source, use the Dockerfile in
[Rogue-Network](https://github.com/rogueisles/Rogue-Network).

## Changes in 4.1.0

Optional SOQ work joins DGB/DOGE, with registry support for compatible future
coins and treasury rotation. The target becomes 12.5 seconds at activation;
genesis, balances and rewards per block remain unchanged.

- [Docker Hub](https://hub.docker.com/r/roguenetwork/rogue-network)
- [Node source](https://github.com/rogueisles/Rogue-Network)
- [Native binaries](https://github.com/rogueisles/Rogue-Node/releases/tag/v4.1.0)
- [Protocol reference](https://github.com/rogueisles/Rogue-Network/blob/main/docs/FORGE-V5-REGISTRY.md)
- [Pool integration](https://github.com/rogueisles/Mining-Pool)
