#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required but not found."
  exit 1
fi

if docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD=(docker-compose)
else
  echo "docker compose or docker-compose not found."
  exit 1
fi

ENV_FILE="${ENV_FILE:-}"
if [ -z "$ENV_FILE" ]; then
  if [ -n "${NETWORK:-}" ]; then
    ENV_FILE="networks/${NETWORK}/.env"
  elif [ -f "networks/mainnet/.env" ]; then
    ENV_FILE="networks/mainnet/.env"
  fi
fi

if [ -n "$ENV_FILE" ] && [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  . "$ENV_FILE"
  set +a
else
  ENV_FILE=""
fi

compose_args=(-f docker-compose.yml)
if [ -n "$ENV_FILE" ]; then
  compose_args=(--env-file "$ENV_FILE" "${compose_args[@]}")
fi
if [ -n "${NETWORK:-}" ]; then
  compose_args=(-p "siberium-${NETWORK}" "${compose_args[@]}")
fi

default_domains_list=()
if [ -n "${MAIN_DOMAIN:-}" ]; then
  default_domains_list+=("$MAIN_DOMAIN")
fi
if [ -n "${RPC_HOSTS:-}" ]; then
  for d in $RPC_HOSTS; do
    default_domains_list+=("$d")
  done
fi
if [ -n "${EXPLORER_HOSTS:-}" ]; then
  for d in $EXPLORER_HOSTS; do
    default_domains_list+=("$d")
  done
fi

unique_domains=()
for d in "${default_domains_list[@]}"; do
  if [ -n "$d" ] && ! printf '%s\n' "${unique_domains[@]}" | grep -qx "$d"; then
    unique_domains+=("$d")
  fi
done

default_domains="${unique_domains[*]}"

read -rp "Domain names (space separated) [${default_domains}]: " input_domains
domains="${input_domains:-$default_domains}"
if [ -z "$domains" ]; then
  echo "No domains provided."
  exit 1
fi

email_default="${CERT_EMAIL:-}"
read -rp "Email for Let's Encrypt [${email_default}]: " input_email
email="${input_email:-$email_default}"
if [ -z "$email" ]; then
  echo "No email provided."
  exit 1
fi

data_path="./data/certbot"
mkdir -p "$data_path/conf" "$data_path/www"

if [ ! -f "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -f "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "Downloading recommended TLS parameters..."
  curl -fsSL \
    "https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/options-ssl-nginx.conf" \
    -o "$data_path/conf/options-ssl-nginx.conf"
  curl -fsSL \
    "https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem" \
    -o "$data_path/conf/ssl-dhparams.pem"
fi

primary_domain="$(printf '%s\n' $domains | head -n 1)"

echo "Creating dummy certificate for ${primary_domain}..."
mkdir -p "$data_path/conf/live/$primary_domain"
openssl req -x509 -nodes -newkey rsa:2048 -days 1 \
  -keyout "$data_path/conf/live/$primary_domain/privkey.pem" \
  -out "$data_path/conf/live/$primary_domain/fullchain.pem" \
  -subj "/CN=localhost"

echo "Starting gateway..."
"${COMPOSE_CMD[@]}" "${compose_args[@]}" up -d gateway

echo "Deleting dummy certificate for ${primary_domain}..."
rm -rf "$data_path/conf/live/$primary_domain"
rm -rf "$data_path/conf/archive/$primary_domain"
rm -f "$data_path/conf/renewal/$primary_domain.conf"

domain_args=()
for d in $domains; do
  domain_args+=("-d" "$d")
done

echo "Requesting Let's Encrypt certificate for: $domains"
"${COMPOSE_CMD[@]}" "${compose_args[@]}" run --rm certbot certonly \
  --webroot -w /var/www/certbot \
  --email "$email" \
  --agree-tos \
  --no-eff-email \
  "${domain_args[@]}"

echo "Reloading gateway..."
"${COMPOSE_CMD[@]}" "${compose_args[@]}" exec gateway nginx -s reload

echo "Done."
