#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for script in macos-packages.sh macos-setup.sh macos.sh symlink-macos.sh svim/install.sh svim/activate.sh; do
  bash -n "$repo_dir/$script"
done

output=$(bash "$repo_dir/macos-setup.sh" --dry-run)
printf '%s\n' "$output" | awk '
  /==> Install Homebrew packages/ { packages = NR }
  /==> Link configuration/ { links = NR }
  /==> Install pinned runtimes/ { runtimes = NR }
  /==> Configure Codex and Headroom/ { agent = NR }
  /==> Start AeroSpace/ { aerospace = NR }
  /==> Verify patched SketchyVim/ { svim = NR }
  /==> Apply Spotify theme/ { spotify = NR }
  END { exit !(packages && packages < links && links < runtimes && runtimes < agent && agent < aerospace && aerospace < svim && svim < spotify) }
'
test_home=$(mktemp -d)
trap 'rm -rf -- "$test_home"' EXIT
printf 'existing\n' > "$test_home/.zshrc"
HOME="$test_home" bash "$repo_dir/symlink-macos.sh" >/dev/null
[[ -L "$test_home/.zshrc" ]]
set -- "$test_home"/.zshrc_backup_*
[[ $# -eq 1 && $(< "$1") == existing ]]
HOME="$test_home" bash "$repo_dir/symlink-macos.sh" >/dev/null
set -- "$test_home"/.zshrc_backup_*
[[ $# -eq 1 ]]
grep -q '__HOME__/Library/Logs/svim.log' "$repo_dir/svim/com.dotfiles.svim.plist"
printf 'macos setup dry-run: OK\n'
