# Rogue Network — Docker node

Official RGN node image for the FORGE mainnet upgrade at block **1,100,100**.

- Chain/network ID: **70088**.
- Same binary as the verified Linux v3.0.0 release.
- Persistent data, automatic peer connections and restart support.
- Ordinary nodes need no wallet, DGB/DOGE daemon or signer service.
- Historical rules/rewards apply through block **1,100,099**.

## Run a regular node

```bash
docker pull roguenetwork/rogue-network:3.0.0

docker run -d \
  --name rgn-node \
  --restart unless-stopped \
  --stop-timeout 120 \
  -p 127.0.0.1:18545:18545 \
  -p 30303:30303/tcp \
  -p 30303:30303/udp \
  -v rgn-data:/var/lib/rgn \
  roguenetwork/rogue-network:3.0.0
```

The named volume `rgn-data` persists across container replacement. The node runs
as UID/GID **10001**. For a host-directory mount, arrange ownership before use;
do not point a second process at an existing running node database.

RPC is available on the host at `http://127.0.0.1:18545`. The example keeps it
local to the server. Public P2P uses TCP/UDP **30303**. HTTP modules are
`eth,net,web3`; administrative and wallet-unlock modules are not exposed.

## Check the node

```bash
docker logs -f rgn-node
docker exec rgn-node python3 /opt/rgn/docker/health.py

curl -s http://127.0.0.1:18545 \
  -H 'Content-Type: application/json' \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

The local health check verifies the exact mainnet genesis and consensus
configuration. Full synchronization additionally requires connected peers and
a height matching the canonical network. `eth_syncing=false` at height zero
does not prove that a newly started node is caught up.

```bash
docker stop -t 120 rgn-node
docker start rgn-node
docker restart -t 120 rgn-node
```

## Wallet selection and solo mining

The optional `WALLET=0xYourPublicRGNAddress` setting selects the RGN work
beneficiary for compatible external FORGE mining software. It does **not**
start a complete solo miner. No private key is required by the node.

FORGE solo mining also requires a Scrypt mining adapter, own DigiByte and/or
Dogecoin native backend, and automatic approvals from the approved **2-of-4**
signing services. The complete solo stack is separate and is not included in
this node image. Do not reuse old ProgPoW wallet-only mining instructions.

## Release identity

Linux/AMD64 image, based on Ubuntu22.04. Source:
https://github.com/rogueisles/Rogue-Network

Source commit: `18367e0aea25899af7fe8d608f0a19fa420740a9`.

Node binary SHA256:
`896166f853530bf74e2282e9950097801e5d88b5d306a6a639ce05f7d243cf05`.

The inherited executable name/version banner is `egem` / `1.0.3-syrius`;
release commit and checksum identify this build. The runtime explicitly selects
network70088. Normal state garbage collection is enabled; this does not bound
all historical block storage. Plan SSD capacity for a growing chain database.

Version `3.0.0` is the fixed release tag. `latest` is a convenience alias.
Release notes and native Linux download:
https://github.com/rogueisles/Rogue-Network/releases/tag/v3.0.0
