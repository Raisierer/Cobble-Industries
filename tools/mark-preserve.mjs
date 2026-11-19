#!/usr/bin/env node
// Marks player-facing client config files as `preserve = true` in index.toml.
// packwiz-installer then installs them only if missing and never overwrites a
// player's changes on update. Server/common configs stay pack-controlled.
//
// Run via tools/refresh.sh (packwiz refresh -> this script -> packwiz refresh).
import fs from "node:fs";
import path from "node:path";

const root = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..");
const indexPath = path.join(root, "index.toml");

// Paths are relative to the pack root.
const PRESERVE = [
  // Generic: any file or folder named like *-client.*, *_client.*, client.json, .../client/...
  /^config\/(.*[-_/.])?client([-_./]|$)/i,
  // Client-only mods whose configs don't carry "client" in the name
  /^config\/DistantHorizons\.toml$/,
  /^config\/MouseTweaks\.cfg$/,
  /^config\/ReactiveMusic\.json5$/,
  /^config\/chunksmith-lod\.properties$/,
  /^config\/dynamic_fps\.json$/,
  /^config\/entityculling\.json$/,
  /^config\/euphoria_patcher\//,
  /^config\/freecam\.json5$/,
  /^config\/immediatelyfast\.json$/,
  /^config\/iris(-excluded\.json|\.properties)$/,
  /^config\/jade\//,
  /^config\/jei\/(?!blacklist\.json$)/, // JEI UI settings; blacklist stays pack-controlled (hides items)
  /^config\/justzoom\//,
  /^config\/moreoverlays\.toml$/,
  /^config\/pingwheel\.json$/,
  /^config\/sodium-options\.json$/,
  /^config\/sound_physics_remastered\//,
  /^config\/betterxray\.json$/,
  /^config\/xray\//,
  // Iris per-shaderpack settings (shaderpacks/<pack>.txt)
  /^shaderpacks\/[^/]+\.txt$/,
];

const text = fs.readFileSync(indexPath, "utf8");
// index.toml is a list of [[files]] tables; handle each block independently.
const blocks = text.split(/(?=^\[\[files\]\]$)/m);
let marked = 0, already = 0;
const out = blocks.map((block) => {
  const m = block.match(/^file = "((?:[^"\\]|\\.)*)"$/m);
  if (!m || /^metafile = true$/m.test(block)) return block;
  const file = JSON.parse(`"${m[1]}"`);
  if (!PRESERVE.some((re) => re.test(file))) return block;
  if (/^preserve = true$/m.test(block)) { already++; return block; }
  marked++;
  return block.replace(/^(hash = "[^"]*")$/m, "$1\npreserve = true");
});
fs.writeFileSync(indexPath, out.join(""));
console.log(`preserve: ${marked} newly marked, ${already} already marked`);
