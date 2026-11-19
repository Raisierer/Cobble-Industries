# Cobble Industries – Colonies

**Catch Pokémon, build factories and airships, and grow a MineColonies town.**

A NeoForge modpack for **Minecraft 1.21.1** (NeoForge 21.1.265) with about 280 mods, built around
[Cobblemon](https://modrinth.com/mod/cobblemon), [Create](https://modrinth.com/mod/create) and
[MineColonies](https://www.curseforge.com/projects/245506). It's managed with
[packwiz](https://packwiz.infra.link/), so Prism instances and servers update themselves from this repo.

## What's inside

| | Highlights |
|---|---|
| **Cobblemon** | Mega Showdown, Ultra-Beasts, Radical Cobblemon Trainers, Legendary Monuments, Monuments of Hoenn, Fight or Flight, Cobblemon Colonies, Create × Cobblemon integrations, Complete Cobblemon Collection & Expanded Spawns |
| **Create** | Aeronautics (airships, hot air balloons, propellers) via Sable, Steam 'n' Rails, Train Parts, Create Big Cannons, TFMG, Diesel Generators, New Age, Nuclear, Power Grid, Northstar (space travel), Numismatics, Enchantment Industry, Deco & Copycats+ |
| **MineColonies** | Style packs (Byzantine, Rustic, Stylecolonies, SmallColonies), AE2Colonies, MineColonies × Create, ComputerCraft integration, Custom Raids |
| **Tech & storage** | Applied Energistics 2, CC: Tweaked, Sophisticated Backpacks & Storage, Stargate Journey |
| **Magic & combat** | Iron's Spells 'n Spellbooks with addons, Better Combat, Apothic Attributes |
| **Exploration** | Twilight Forest, The Aether, Alex's Caves, Bumblezone, BetterEnd/BetterNether, Cataclysm, Mowzie's Mobs, Bosses' Rise, Terralith, Tectonic, Biomes O' Plenty, YUNG's, Integrated Dungeons & Structures, Lootr |
| **Quality of life** | JEI (+ JER, JEP, WorldGen), Jade, JourneyMap, FTB Chunks & Teams, Ping Wheel, Corpse, Quark, Supplementaries |
| **Client** | Sodium, Iris with Complementary Unbound + Euphoria Patches, Distant Horizons, Sound Physics Remastered, Fusion connected textures |

The full list is in [`mods/`](mods), one `.pw.toml` file per mod.

### Pack-specific tweaks
- **Legendary Pokémon spawn on Northstar planets and moons.** Mewtwo, Rayquaza, Deoxys and others need a rocket to find. See `datapacks/zzz_cobble_industries_custom_datapack.zip`.
- **Unified radioactive materials:** Alex's Caves uranium becomes Create Nuclear raw uranium, and Create New Age thorium becomes Create Nuclear thorium dust (`kubejs/server_scripts/`).
- **Removed recipes:** the Diesel Generators pumpjack and oil scanner, and Iron's Spells portal frames (`kubejs/server_scripts/item_blacklist.js`).
- **Ores and materials** are unified with Almost Unified.

## Installing

Download the files from the [latest release](https://github.com/Raisierer/Cobble-Industries/releases/latest).

### Prism Launcher (recommended)
1. **Add Instance → Import**, then select `Cobble-Industries-<version>-prism.zip`.
2. **Before the first launch:** download [SmallColonies for MineColonies](https://www.curseforge.com/projects/1232237) (`smallcolonies 1.21.1 v1.8.jar`) from CurseForge. To find the folder, right-click the instance and choose **Folder**, then put the jar into `.minecraft/mods/`. CurseForge doesn't allow this file to be downloaded automatically.
3. Launch the instance. A small installer window downloads the mods, which takes a few minutes the first time.

After that, **the instance updates itself on every launch** to the newest stable release. Your settings are kept: `options.txt`, keybinds, client-side mod configs and shader settings are installed once and never overwritten. Server and gameplay configs follow the pack.

The installer asks whether you want **Metal Upscaler** (DLSS/FSR/MetalFX upscaling). It's optional and off by default. If you want it, download the jar from [CurseForge](https://www.curseforge.com/projects/1669444) and put it into `mods/` the same way.

### CurseForge app
**Create Custom Profile → Import**, then select `Cobble-Industries-<version>-curseforge.zip`. CurseForge downloads every mod itself, including SmallColonies.

This profile doesn't update itself. For each new release, import the new zip. Importing resets the pack's config files, but keeps `options.txt` and keybinds.

## Performance tips
- **RAM:** give the game **8–12 GB**. The Prism instance is preset to 4–12 GB. Less than 8 GB causes stutters, and more than 12 GB rarely helps.
- **Shaders** (Complementary + Euphoria) cost the most performance. Turn them off with **K** or under *Options → Video Settings → Shader Packs*.
- **Distant Horizons** renders far terrain. If FPS is low, lower its quality or render distance in the DH settings (the button in *Video Settings*). The server sends the terrain data, so you don't have to explore an area first to see it.
- Keep the normal **render distance at 8–12** and let Distant Horizons draw everything beyond that.
- **Dynamic FPS** lowers the frame rate while the game is in the background, so tabbing out is fine.
- If memory use keeps growing, `/spark` and `F3` help find the cause. Restarting the game also helps.

## Known issues
- **SmallColonies must be downloaded by hand** for Prism (see above). Without it, the installer stops with an error before Minecraft starts.
- **Right after a release**, the first launch can fail with a hash error for up to about 5 minutes while GitHub's CDN catches up. Launch again a few minutes later.
- **The CurseForge app doesn't update itself.** Use Prism if you want automatic updates.
- **Harmless log noise:** you may see warnings about unknown structures, refmaps or a lectern mixin conflict (Amendments vs Iron's Spells) in the log. You can ignore them.

---

## Running a server

`server/docker-compose.yml` runs the pack using [itzg/minecraft-server](https://docker-minecraft-server.readthedocs.io/). On every start the container syncs server-side mods and configs from the release you choose and skips client-only mods.

```sh
cd server
cp .env.example .env    # set PACK_VERSION, NEOFORGE_VERSION, RCON_PASSWORD
docker compose up -d
docker compose logs -f
```

| `.env` variable | Meaning |
|---|---|
| `PACK_VERSION` | Release tag such as `v0.58.0`, pinned and reproducible. `release` follows the latest stable release, and `main` tracks development. |
| `NEOFORGE_VERSION` | Must match the release. Each release's notes list both values. |
| `RCON_PASSWORD` | Required. Use it for console access with `docker exec -it cobble-industries rcon-cli`. |
| `GAME_PORT` / `LOD_PORT` | Default `25565` / `25566`. Keep host and container ports identical, because Chunksmith tells clients its LOD port. |
| `MEMORY` | Default `12G`. |

**Updating the server:** set the new `PACK_VERSION` and `NEOFORGE_VERSION` in `.env`, then run `docker compose up -d`.

**SmallColonies** must also be placed by hand in `server/data/mods/`.

---

## Maintaining the pack

You need [packwiz](https://packwiz.infra.link/). It's included in the devenv shell (`devenv shell`).

### Repository layout
| Path | Contents |
|---|---|
| `pack.toml`, `index.toml` | packwiz pack definition and file index (generated, don't edit `index.toml` by hand) |
| `mods/`, `resourcepacks/`, `shaderpacks/`, `datapacks/` | one `.pw.toml` per downloaded file, plus a few bundled files |
| `config/`, `kubejs/` | configs and scripts shipped to players and the server |
| `tools/` | maintenance scripts (not shipped) |
| `prism/` | Prism instance builder (not shipped) |
| `server/` | Docker Compose server setup (not shipped) |
| `.github/workflows/release.yml` | release automation |

### Day to day
- **Add a mod:** `packwiz modrinth add <slug>` or `packwiz curseforge add <slug>`. packwiz may pull in or update dependencies, so check `git diff` before committing.
- **Set sides:** client-only mods need `side = "client"` in their `.pw.toml`, so the server never installs them.
- **After any change, run `tools/refresh.sh` instead of `packwiz refresh`.** It also marks player-facing client configs with `preserve = true`, which means "install once, never overwrite". The patterns are in `tools/mark-preserve.mjs`.
- **Changing a preserved default:** players who already have the file keep their version. To force a change, temporarily remove the file from the preserve patterns for one release.
- **Local junk** (JEI world data, caches, backups) is excluded in `.packwizignore`.

### Releasing
```sh
tools/release.sh 0.58.0                 # sets pack.toml version, refreshes the index
jj commit -m "release v0.58.0"          # or git commit
jj bookmark set main -r @- && jj git push
git tag v0.58.0 main && git push origin v0.58.0
```
Pushing a `vX.Y.Z` tag runs the **Release** workflow, which:
1. checks that the tag matches `pack.toml` and that `index.toml` is up to date;
2. builds the CurseForge zip (`packwiz curseforge export`) and the Prism zip (`prism/build-instance.sh`);
3. creates the GitHub release with install notes, the server `.env` values and a mod changelog since the previous tag;
4. moves the `release` branch to the tag. Prism instances and servers using `PACK_VERSION=release` then pick it up.

Tags with a suffix, such as `v0.58.0-beta.1`, become **pre-releases**. They don't move `release`, and their Prism zip stays pinned to that tag, which makes them useful for testing.

## Credits
All mods, resource packs and shaders belong to their respective authors and are downloaded from Modrinth and CurseForge under their own licenses.
