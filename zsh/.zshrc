##############################################################################
# DO_NOT_BACK_UP_FILE
##############################################################################
# Overrides all locale settings to enforce a consistent language, encoding, and formatting.
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
# Disable Homebrew auto update
export HOMEBREW_NO_AUTO_UPDATE=1
# Prepend to system path
export PATH=$HOME/bin:/usr/local/bin:$PATH
# Initialize nvm in shell
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion"
export FUNCNEST=100
# Enable Starship prompt
if command -v starship &> /dev/null; then
  export STARSHIP_CONFIG=~/.config/starship/starship.toml
  # Fixes: starship_zle-keymap-select-wrapped:1: maximum nested function level reached; increase FUNCNEST?
  # See: https://github.com/starship/starship/issues/3418#issuecomment-2477375663
  if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
    "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
  fi
  eval "$(starship init zsh)"
fi
# Homebrew setup (macOS)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [[ -d "$(brew --prefix)/share/zsh-completions" ]]; then
  fpath+="$(brew --prefix)/share/zsh-completions"
  autoload -Uz compinit && compinit -u
fi
# Ensure fzf-tab is installed
if [[ ! -d "$HOME/.zsh/fzf-tab" ]]; then
  git clone https://github.com/Aloxaf/fzf-tab "$HOME/.zsh/fzf-tab"
fi
if [[ -f "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh"
fi
if [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [[ -f "$(brew --prefix)/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
fi
if [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
##############################################################################
# Keybindings
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
##############################################################################
# History settings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups
##############################################################################
# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
##############################################################################
# Print execution time after every terminal command
preexec() {
  timer=$(gdate +%s.%N)
}
precmd() {
  if [ -n "$timer" ]; then
    now=$(gdate +%s.%N)
    elapsed=$(echo "$now - $timer" | bc)
    timer_show=$(printf "%.2f" $elapsed)
    echo "Execution time: ${timer_show}s"
    unset timer
  fi
}
##############################################################################
# ALIASES
alias ls='ls --color'
alias vim='nvim'
alias v='nvim'
alias c='clear'
alias ll='ls -lh'
alias lla='ls -alh'
alias python='python3'
# Shows the last 30 entries, default is 15
alias history='history -30'
alias x='exit'
alias chrome="open -a 'Google Chrome'"
##############################################################################
# Ensure Tmux Plugin Manager is installed
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
##############################################################################
