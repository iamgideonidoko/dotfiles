#!/usr/bin/env bash
# Build pinned SketchyVim with zombie-child reaping.
set -euo pipefail

revision=b9b656dd7a49c1c5daa84a54c73c0aab778bfeb5
repository=https://github.com/FelixKratz/SketchyVim.git
root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source_dir=${SVIM_SOURCE_DIR:-"$HOME/.local/src/SketchyVim-patched-v1.0.11"}
install_dir=${SVIM_INSTALL_DIR:-"$HOME/.local/opt/svim"}
patch_file="$root_dir/patches/0001-reap-script-children.patch"

command -v git >/dev/null
command -v make >/dev/null
command -v clang >/dev/null
test -f "$patch_file"

if [[ ! -d "$source_dir/.git" ]]; then
  mkdir -p "$(dirname "$source_dir")"
  git clone --depth 1 --branch v1.0.11 "$repository" "$source_dir"
fi

test "$(git -C "$source_dir" remote get-url origin)" = "$repository"
git -C "$source_dir" fetch --depth 1 origin "$revision"
git -C "$source_dir" checkout --detach "$revision"

if git -C "$source_dir" apply --reverse --check "$patch_file"; then
  :
elif git -C "$source_dir" apply --check "$patch_file"; then
  git -C "$source_dir" apply "$patch_file"
else
  printf 'unexpected SketchyVim source state; refusing to build\n' >&2
  exit 1
fi

make -C "$source_dir" clean
test -f "$source_dir/lib/libvim.a"
make -C "$source_dir"

mkdir -p "$install_dir/bin"
install -m 755 "$source_dir/bin/svim" "$install_dir/bin/svim"
codesign --force --sign - --identifier com.dotfiles.svim --timestamp=none "$install_dir/bin/svim"
codesign --verify --strict --verbose=2 "$install_dir/bin/svim"
printf 'revision=%s\npatch_sha256=%s\n' "$revision" "$(shasum -a 256 "$patch_file" | awk '{print $1}')" >"$install_dir/BUILD-INFO"
printf 'installed patched svim: %s\n' "$install_dir/bin/svim"
