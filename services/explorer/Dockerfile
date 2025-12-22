FROM blockscout/blockscout:latest

# Branding defaults.
ENV NEXT_PUBLIC_NETWORK_NAME="Siberium" \
    NEXT_PUBLIC_NETWORK_SHORT_NAME="SIBR" \
    NEXT_PUBLIC_COIN_NAME="Siberium Token" \
    NEXT_PUBLIC_COIN_SYMBOL="SIBR" \
    NEXT_PUBLIC_NETWORK_CURRENCY_NAME="Siberium Token" \
    NEXT_PUBLIC_NETWORK_CURRENCY_SYMBOL="SIBR" \
    NEXT_PUBLIC_NETWORK_LOGO="file:///app/assets/logo.svg" \
    NEXT_PUBLIC_NETWORK_ICON="file:///app/assets/favicon.png" \
    ETHEREUM_JSONRPC_VARIANT="geth" \
    CHAIN_TYPE="mainnet" \
    NETWORK="Siberium" \
    SUBNETWORK="Siberium" \
    COIN="SIBR" \
    COIN_NAME="Siberium Token" \
    LOGO="/images/logo.svg" \
    LOGO_TEXT="Siberium" \
    FOOTER_LOGO="/images/logo.svg" \
    NETWORK_ICON="/images/favicon.png" \
    DISABLE_WEBAPP="false"

# Cyberpunk blue/black theme overrides (Blockscout frontend if enabled).
ENV NEXT_PUBLIC_COLOR_THEME_DEFAULT="midnight" \
    NEXT_PUBLIC_COLOR_THEME_OVERRIDES="{\"bg\":{\"primary\":{\"_dark\":{\"value\":\"#05070d\"}}},\"text\":{\"primary\":{\"_dark\":{\"value\":\"rgba(214,244,255,0.92)\"}},\"secondary\":{\"_dark\":{\"value\":\"rgba(143,199,255,0.7)\"}}},\"link\":{\"primary\":{\"_dark\":{\"value\":\"#2bd5ff\"}}},\"button\":{\"primary\":{\"_dark\":{\"value\":\"#1f8cff\"}}},\"hover\":{\"_dark\":{\"value\":\"#2bd5ff\"}},\"navigation\":{\"bg\":{\"selected\":{\"_dark\":{\"value\":\"rgba(43,213,255,0.12)\"}}},\"text\":{\"selected\":{\"_dark\":{\"value\":\"#c9f3ff\"}}}}}"

# Brand assets from the build context.
COPY assets/logo.svg /app/assets/logo.svg
COPY assets/favicon.png /app/assets/favicon.png

# Place assets where both classic Blockscout and frontend expect them.
RUN set -eu; \
    blockscout_web_dir="$(ls -d /app/lib/block_scout_web-* 2>/dev/null | head -n 1 || true)"; \
    if [ -n "$blockscout_web_dir" ]; then \
      mkdir -p "$blockscout_web_dir/priv/static/images"; \
      cp /app/assets/logo.svg "$blockscout_web_dir/priv/static/images/logo.svg"; \
      cp /app/assets/favicon.png "$blockscout_web_dir/priv/static/images/favicon.png"; \
      cp /app/assets/favicon.png "$blockscout_web_dir/priv/static/favicon.png"; \
    fi; \
    mkdir -p /app/public/assets/configs; \
    cp /app/assets/logo.svg /app/public/assets/configs/network_logo.svg; \
    cp /app/assets/favicon.png /app/public/assets/configs/network_icon.png

COPY config/feature-flags.env /app/config/feature-flags.env
COPY entrypoint.sh /app/bin/entrypoint.sh
RUN chmod +x /app/bin/entrypoint.sh

ENTRYPOINT ["/app/bin/entrypoint.sh"]
