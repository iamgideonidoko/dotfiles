unalias wps 2>/dev/null
wps() {
  local selected
  selected=$("$HOME/.local/bin/dotfiles-window" list) || return
  selected=$(printf '%s\n' "$selected" | fzf) || return
  "$HOME/.local/bin/dotfiles-window" navigate "${${selected%%[[:space:]|]*}//[[:space:]]/}"
}
