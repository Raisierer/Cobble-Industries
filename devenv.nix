{
  pkgs,
  lib,
  config,
  ...
}:

let
  root = config.devenv.root;
  version = "$(sed -n 's/^version = \"\\(.*\\)\"/\\1/p' ${root}/pack.toml)";
in
{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    packwiz
    nodejs # tools/mark-preserve.mjs
    curl # prism/build-instance.sh (bootstrap jar)
    zip
    unzip
    jdk21_headless # running packwiz-installer locally for test installs
  ];

  # https://devenv.sh/scripts/ — all scripts run from the repo root.
  scripts = {
    pack-refresh = {
      description = "packwiz refresh + preserve flags for client configs (use instead of `packwiz refresh`)";
      exec = ''cd ${root} && tools/refresh.sh "$@"'';
    };

    pack-check = {
      description = "Fail if index.toml/pack.toml are stale (same check as the release workflow)";
      exec = ''
        cd ${root}
        tools/refresh.sh >/dev/null
        if ! git diff --quiet -- index.toml pack.toml; then
          git diff --stat -- index.toml pack.toml
          echo "index was stale and has been refreshed — review and commit the changes" >&2
          exit 1
        fi
        echo "index up to date"
      '';
    };

    pack-release = {
      description = "Prepare a release: pack-release <semver>, e.g. pack-release 0.58.0";
      exec = ''cd ${root} && tools/release.sh "$@"'';
    };

    pack-changelog = {
      description = "Mod changelog between two refs: pack-changelog <from> [to=HEAD]";
      exec = ''cd ${root} && tools/changelog.sh "''${1:?usage: pack-changelog <from-ref> [to-ref]}" "''${2:-HEAD}"'';
    };

    pack-prism = {
      description = "Build the Prism instance zip: pack-prism [pack.toml URL] [output zip]";
      exec = ''cd ${root} && prism/build-instance.sh "$@"'';
    };

    pack-cf = {
      description = "Export the CurseForge zip to build/";
      exec = ''
        cd ${root} && mkdir -p build
        packwiz -y curseforge export -o "build/Cobble-Industries-${version}-curseforge.zip"
      '';
    };

    pack-build = {
      description = "Build both release zips locally (CurseForge + Prism) into build/";
      exec = ''
        set -e
        pack-check
        pack-cf
        pack-prism "" "${root}/build/Cobble-Industries-${version}-prism.zip"
        ls -lh ${root}/build/*.zip
      '';
    };

    pack-serve = {
      description = "Serve the pack locally at http://localhost:8080/pack.toml (for test installs)";
      exec = ''cd ${root} && packwiz serve "$@"'';
    };
  };

  enterShell = ''
    echo "Cobble Industries $(sed -n 's/^version = "\(.*\)"/\1/p' pack.toml) — pack tools:"
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: s: ''printf '  %-15s %s\n' ${lib.escapeShellArg name} ${lib.escapeShellArg s.description}''
      ) (lib.filterAttrs (n: _: lib.hasPrefix "pack-" n) config.scripts)
    )}
  '';

  # `devenv test`: same consistency check CI runs before releasing.
  enterTest = ''
    pack-check
    bash -n tools/*.sh prism/build-instance.sh
  '';
}
