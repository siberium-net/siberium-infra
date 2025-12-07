FROM ethereum/client-go:v1.13.14

# Network configuration - can be overridden at runtime
ENV NETWORK_NAME=mainnet
ENV NETWORK_ID=111111

RUN apk add --no-cache bash curl

COPY services/node/entrypoint.sh /usr/local/bin/entrypoint.sh

# Copy genesis file - ARG used only at build time
ARG NETWORK_NAME=mainnet
COPY networks/${NETWORK_NAME}/genesis.json /root/genesis.json

RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose ports
EXPOSE 8545 8546 30303 30303/udp

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
