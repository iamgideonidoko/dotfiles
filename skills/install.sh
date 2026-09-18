#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="$repo_dir/skills/manifest.json"

test -f "$manifest" || { echo "Missing skills manifest: $manifest" >&2; exit 1; }
jq -e '.version == 1 and (.agents | type == "array") and (.agents | length > 0) and all(.agents[]; type == "string") and (.skills | type == "array") and all(.skills[]; (.name | type == "string") and (.source | type == "string") and ((.installSource? // .source) | type == "string"))' "$manifest" >/dev/null
read -r -a agents <<< "${SKILL_AGENTS:-$(jq -r '.agents | join(" ")' "$manifest")}"

installed_for_agents() {
  local skill="$1"
  local agent
  local installed_skills

  for agent in "${agents[@]}"; do
    installed_skills="$(mise exec -- skills list --global --agent "$agent" --json < /dev/null)"
    jq -e --arg skill "$skill" 'any(.[]; .name == $skill and (.agents | length > 0))' <<< "$installed_skills" >/dev/null || return 1
  done
}

while IFS=$'\t' read -r source skill; do
  if installed_for_agents "$skill"; then
    echo "Skipping $skill (already installed for ${agents[*]})"
    continue
  fi
  mise exec -- skills add "$source" --global --skill "$skill" --agent "${agents[@]}" --yes < /dev/null
done < <(jq -r '.skills[] | [(.installSource // .source), .name] | @tsv' "$manifest")
