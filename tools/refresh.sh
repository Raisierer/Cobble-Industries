#!/usr/bin/env bash
# Use this instead of plain `packwiz refresh`: it also (re)applies the
# preserve flags for player-facing client configs (see tools/mark-preserve.mjs).
set -euo pipefail
cd "$(dirname "$0")/.."
packwiz refresh
node tools/mark-preserve.mjs
packwiz refresh   # re-hash index.toml into pack.toml after the edit

# CI builds from a clean checkout: every indexed file must be tracked by git,
# otherwise the index differs there (e.g. files hidden by a mod's own .gitignore).
ignored=$(sed -n 's/^file = "\(.*\)"$/\1/p' index.toml | git check-ignore --stdin || true)
if [ -n "$ignored" ]; then
  echo "error: indexed but ignored by git, so missing in CI — add to .packwizignore:" >&2
  printf '%s\n' "$ignored" | sed 's/^/  /' >&2
  exit 1
fi
