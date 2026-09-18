#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="$repo_dir/skills/manifest.json"
temp_manifest="$(mktemp)"
existing_manifest="$(mktemp)"
trap 'rm -f "$temp_manifest" "$existing_manifest"' EXIT

if [[ -f "$manifest" ]]; then
  cp "$manifest" "$existing_manifest"
else
  printf '{"skills": []}\n' > "$existing_manifest"
fi

mise exec -- skills list --global --json |
  jq --slurpfile existing "$existing_manifest" '
    ($existing[0].skills // [] | map(select(.installSource != null)) | map({key: .name, value: .installSource}) | from_entries) as $overrides |
    {version: 1, agents: ($existing[0].agents // ["codex"]), skills: [.[] | select(.source != null) | {name, source} + (if $overrides[.name] then {installSource: $overrides[.name]} else {} end)] | sort_by(.source, .name)}
  ' > "$temp_manifest"

mv "$temp_manifest" "$manifest"
