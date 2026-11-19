#!/usr/bin/env bash
# Prepares a release: sets the pack version and refreshes the index.
# Committing and tagging is left to you (works with both jj and git).
# usage: tools/release.sh 0.58.0
set -euo pipefail
cd "$(dirname "$0")/.."
VERSION=${1:?usage: tools/release.sh <semver, e.g. 0.58.0>}
VERSION=${VERSION#v}
[[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]] || { echo "not semver: $VERSION" >&2; exit 1; }
git rev-parse -q --verify "refs/tags/v$VERSION" >/dev/null && { echo "tag v$VERSION already exists" >&2; exit 1; }

sed -i "s/^version = \".*\"/version = \"$VERSION\"/" pack.toml
tools/refresh.sh >/dev/null
echo "pack.toml version = $VERSION, index refreshed."
cat <<EOF

Next:
  jj commit -m "release v$VERSION"        # or: git commit -am "release v$VERSION"
  jj bookmark set main -r @- && jj git push
  git tag v$VERSION main && git push origin v$VERSION
EOF
