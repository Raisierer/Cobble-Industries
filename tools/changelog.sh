#!/usr/bin/env bash
# Prints a markdown list of added/removed/updated mods between two git refs.
# usage: tools/changelog.sh <from-ref> <to-ref>
set -euo pipefail
cd "$(dirname "$0")/.."
FROM=$1 TO=$2

field() { # field <ref> <path> <key>
  git show "$1:$2" 2>/dev/null | sed -n "s/^$3 = \"\(.*\)\"$/\1/p" | head -1
}

added=() removed=() updated=()
while IFS=$'\t' read -r status path rest; do
  case "$status" in
    A) added+=("$(field "$TO" "$path" name) (\`$(field "$TO" "$path" filename)\`)") ;;
    D) removed+=("$(field "$FROM" "$path" name)") ;;
    M) old=$(field "$FROM" "$path" filename); new=$(field "$TO" "$path" filename)
       [ "$old" != "$new" ] && updated+=("$(field "$TO" "$path" name): \`$old\` → \`$new\`") ;;
    R*) updated+=("$(field "$TO" "$rest" name): \`$(field "$FROM" "$path" filename)\` → \`$(field "$TO" "$rest" filename)\`") ;;
  esac
done < <(git diff --name-status -M "$FROM" "$TO" -- '*.pw.toml')

section() { local title=$1; shift; [ $# -eq 0 ] && return; echo "### $title"; printf -- '- %s\n' "$@" | sort -f; echo; }
section "Added" "${added[@]}"
section "Updated" "${updated[@]}"
section "Removed" "${removed[@]}"

cfg=$(git diff --name-only "$FROM" "$TO" -- config kubejs datapacks resourcepacks shaderpacks | wc -l)
[ "$cfg" -gt 0 ] && echo "$cfg config/script/datapack file(s) changed."
true
