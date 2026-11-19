#!/usr/bin/env bash
# Builds a Prism Launcher instance zip that installs/updates the pack via packwiz
# on every launch. Players import it with: Prism -> Add Instance -> Import -> zip.
#
# usage: prism/build-instance.sh [pack.toml URL] [output zip]
# Default URL is the `release` branch, which CI moves to every stable tag, so
# instances follow new releases automatically.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PACK_URL="${1:-https://raw.githubusercontent.com/Raisierer/Cobble-Industries/release/pack.toml}"
OUT="$(realpath -m "${2:-$REPO_ROOT/build/Cobble-Industries-prism.zip}")"

# Read Minecraft/NeoForge versions from pack.toml so the instance always matches the pack.
MC_VERSION=$(sed -n 's/^minecraft = "\(.*\)"/\1/p' "$REPO_ROOT/pack.toml")
NEOFORGE_VERSION=$(sed -n 's/^neoforge = "\(.*\)"/\1/p' "$REPO_ROOT/pack.toml")

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
INST="$WORK/Cobble Industries"
mkdir -p "$INST/.minecraft"

cat > "$INST/mmc-pack.json" <<EOF
{
    "components": [
        { "uid": "net.minecraft", "version": "$MC_VERSION", "important": true },
        { "uid": "net.neoforged", "version": "$NEOFORGE_VERSION" }
    ],
    "formatVersion": 1
}
EOF

# PreLaunchCommand runs in the instance's .minecraft folder. packwiz-installer also
# updates mmc-pack.json when the pack's NeoForge version changes.
# Qt INI format: the whole value is quoted and inner quotes escaped, otherwise Prism
# strips the quotes and the space ("javaw.exe-jar ...") and the command fails.
cat > "$INST/instance.cfg" <<EOF
[General]
ConfigVersion=1.2
InstanceType=OneSix
name=Cobble Industries
iconKey=default
OverrideCommands=true
PreLaunchCommand="\\"\$INST_JAVA\\" -jar packwiz-installer-bootstrap.jar $PACK_URL"
OverrideMemory=true
MinMemAlloc=4096
MaxMemAlloc=12288
EOF

curl -fsSL -o "$INST/.minecraft/packwiz-installer-bootstrap.jar" \
  https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar

mkdir -p "$(dirname "$OUT")"
rm -f "$OUT"
(cd "$WORK" && zip -qr "$OUT" "Cobble Industries")
echo "Built $OUT (Minecraft $MC_VERSION, NeoForge $NEOFORGE_VERSION)"
echo "Pack URL: $PACK_URL"
