# Use the official Hyperledger Besu image
FROM hyperledger/besu:latest

# Set the working directory
WORKDIR /besu

# Copy the genesis file and static networking files
# COPY genesis.json        /besu/genesis.json
# COPY networkFiles        /besu/networkFiles

# Copy pre-initialized node data directories
COPY --chown=besu:besu genesis.json /besu/genesis.json
COPY --chown=besu:besu Node-2 /besu/Node-2
COPY --chown=besu:besu networkFiles /besu/networkFiles

RUN rm -rf /besu/Node-2/data/database && \
    mkdir -p /besu/Node-2/data && \
    chown -R besu:besu /besu/Node-2

# Expose P2P, RPC, and metrics ports for nodes 1–4
EXPOSE 30304
EXPOSE 8546 
EXPOSE 9546 

# Entrypoint wraps the besu binary

# Entrypoint wraps the besu binary
ENTRYPOINT ["besu"]

# Default command runs Node-1; override at runtime for other nodes
CMD ["--data-path=/besu/Node-2/data","--genesis-file=/besu/genesis.json","--rpc-http-enabled","--rpc-http-port=8546","--bootnodes=enode://b47663d5fed91287abeb711690fcc5c249aaddcf49eb71fb71e5a5b309b54a52947459beae1e368b5d4b3931eae28e686f7be9f567286fb2a544c5b5fcc9e1fb@216.24.57.4:30303","--rpc-http-api=ETH,NET,QBFT,WEB3","--host-allowlist=*","--rpc-http-cors-origins=all","--profile=ENTERPRISE","--min-gas-price=1000","--version-compatibility-protection=false","--p2p-port=30304","--metrics-enabled","--metrics-host=0.0.0.0","--metrics-port=9545"]


# # syntax=docker/dockerfile:1
# FROM hyperledger/besu:latest

# WORKDIR /besu

# # copy config, network files, and all four data dirs
# COPY genesis.json        /besu/genesis.json
# COPY networkFiles        /besu/networkFiles
# COPY Node-1              /besu/Node-1
# COPY Node-2              /besu/Node-2
# COPY Node-3              /besu/Node-3
# COPY Node-4              /besu/Node-4

# # copy & make executable the multi-node startup script
# COPY start-all-nodes.sh  /besu/start-all-nodes.sh
# RUN chmod +x /besu/start-all-nodes.sh

# # expose all RPC, P2P & metrics ports for nodes 1–4
# EXPOSE 8545 8546 8547 8548
# EXPOSE 30303 30304 30305 30306
# EXPOSE 9545 9546 9547 9548

# ENTRYPOINT ["/besu/start-all-nodes.sh"]
