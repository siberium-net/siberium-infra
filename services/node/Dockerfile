FROM ethereum/client-go:v1.13.14

ARG NETWORK_NAME

RUN apk add --no-cache bash

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY networks/${NETWORK_NAME}/genesis.json /root/genesis.json

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]


