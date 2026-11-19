#!/usr/bin/env bash
# Use this instead of plain `packwiz refresh`: it also (re)applies the
# preserve flags for player-facing client configs (see tools/mark-preserve.mjs).
set -euo pipefail
cd "$(dirname "$0")/.."
packwiz refresh
node tools/mark-preserve.mjs
packwiz refresh   # re-hash index.toml into pack.toml after the edit
