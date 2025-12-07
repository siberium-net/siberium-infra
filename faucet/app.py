import os
import sqlite3
from datetime import datetime, timedelta, timezone
from decimal import Decimal
from typing import Optional

from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
from web3 import Web3
from web3.exceptions import ContractLogicError

FAUCET_PRIVATE_KEY = os.getenv("FAUCET_PRIVATE_KEY")
RPC_URL = os.getenv("RPC_URL", "http://node:8545")
CHAIN_ID = int(os.getenv("CHAIN_ID", "111000"))
FAUCET_AMOUNT = Decimal(os.getenv("FAUCET_AMOUNT", "1"))
DB_PATH = os.getenv("FAUCET_DB_PATH", "/data/db.sqlite")

if not FAUCET_PRIVATE_KEY:
  raise RuntimeError("FAUCET_PRIVATE_KEY is required for faucet service")

w3 = Web3(Web3.HTTPProvider(RPC_URL))
if not w3.is_connected():
  raise RuntimeError(f"Cannot connect to RPC at {RPC_URL}")

account = w3.eth.account.from_key(FAUCET_PRIVATE_KEY)

app = FastAPI(title="Siberium Faucet", version="0.1.0")


class ClaimRequest(BaseModel):
  address: str


def get_db() -> sqlite3.Connection:
  os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
  conn = sqlite3.connect(DB_PATH)
  conn.row_factory = sqlite3.Row
  return conn


def init_db() -> None:
  conn = get_db()
  try:
    conn.execute(
      """
      CREATE TABLE IF NOT EXISTS requests (
        ip TEXT PRIMARY KEY,
        last_request TEXT NOT NULL
      )
      """
    )
    conn.commit()
  finally:
    conn.close()


def is_rate_limited(ip: str, now: datetime) -> bool:
  conn = get_db()
  try:
    row = conn.execute("SELECT last_request FROM requests WHERE ip = ?", (ip,)).fetchone()
    if not row:
      return False
    last = datetime.fromisoformat(row["last_request"])
    return now - last < timedelta(days=1)
  finally:
    conn.close()


def record_request(ip: str, when: datetime) -> None:
  conn = get_db()
  try:
    conn.execute(
      "INSERT OR REPLACE INTO requests (ip, last_request) VALUES (?, ?)",
      (ip, when.isoformat()),
    )
    conn.commit()
  finally:
    conn.close()


def send_funds(to_address: str) -> str:
  checksum_address = Web3.to_checksum_address(to_address)
  nonce = w3.eth.get_transaction_count(account.address)
  gas_price = w3.eth.gas_price
  tx = {
    "to": checksum_address,
    "value": int(FAUCET_AMOUNT * (10**18)),
    "nonce": nonce,
    "gas": 21000,
    "gasPrice": gas_price,
    "chainId": CHAIN_ID,
  }
  signed_tx = account.sign_transaction(tx)
  tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
  return tx_hash.hex()


@app.on_event("startup")
def startup() -> None:
  init_db()


@app.get("/health")
def health() -> dict:
  return {"status": "ok", "chain_id": CHAIN_ID, "rpc": RPC_URL}


@app.post("/claim")
async def claim(req: Request, body: ClaimRequest) -> dict:
  client_ip: Optional[str] = req.client.host if req.client else None
  if not client_ip:
    raise HTTPException(status_code=400, detail="Cannot determine client IP")

  now = datetime.now(timezone.utc)
  if is_rate_limited(client_ip, now):
    raise HTTPException(status_code=429, detail="Rate limit: 1 request per 24h per IP")

  try:
    tx_hash = send_funds(body.address)
  except ContractLogicError as exc:
    raise HTTPException(status_code=400, detail=f"Transfer failed: {exc}") from exc
  except ValueError as exc:
    raise HTTPException(status_code=400, detail=str(exc)) from exc
  except Exception as exc:  # pylint: disable=broad-except
    raise HTTPException(status_code=500, detail="Internal error") from exc

  record_request(client_ip, now)

  return {
    "tx_hash": tx_hash,
    "from": account.address,
    "to": Web3.to_checksum_address(body.address),
    "amount": str(FAUCET_AMOUNT),
    "chain_id": CHAIN_ID,
  }


