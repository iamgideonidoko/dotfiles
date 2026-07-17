##############################################################################
# DO_NOT_BACK_UP_FILE
##############################################################################

# Load ZSH Env
if [[ -f "$HOME/dotfiles/zsh/.env" ]]; then
  set -a
  source "$HOME/dotfiles/zsh/.env"
  set +a
fi

##############################################################################

# Homebrew setup (macOS)
if [[ -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH+:$INFOPATH}"
fi

export XDG_CONFIG_HOME="$HOME/.config"
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export HOMEBREW_NO_AUTO_UPDATE=1

# Prepend to system path
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export NVM_DIR="$HOME/.nvm"

NVM_COMMANDS=(nvm node npm npx yarn pnpm corepack nvim)

lazy_load_nvm() {
  unset -f "${NVM_COMMANDS[@]}"
  [[ -s /opt/homebrew/opt/nvm/nvm.sh ]] || return
  source /opt/homebrew/opt/nvm/nvm.sh
  [[ -s /opt/homebrew/opt/nvm/etc/bash_completion ]] &&
    source /opt/homebrew/opt/nvm/etc/bash_completion

  if [[ -z "$NVM_BIN" ]]; then
    [[ -f "$NVM_DIR/alias/default" ]] || {
      echo "No default Node version found. Installing latest LTS..."
      nvm install --lts
      nvm alias default "lts/*"
    }
    nvm use default --silent >/dev/null 2>&1
  fi
}

for cmd in "${NVM_COMMANDS[@]}"; do
  eval "${cmd}() { lazy_load_nvm; ${cmd} \"\$@\"; }"
done
autoload -U add-zsh-hook

load-nvmrc() {
  [[ -f .nvmrc ]] || return
  (($+functions[nvm])) || load_nvm
  nvm use --silent
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

export FUNCNEST=100

# Enable Starship prompt
if command -v starship &>/dev/null; then
  export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
  if [[ "${widgets['zle-keymap-select']#user:}" == "starship_zle-keymap-select" ||
    "${widgets['zle-keymap-select']#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select ""
  fi
  eval "$(starship init zsh)"
fi

# Set path variable without calling brew command (fast)
if [[ -d /opt/homebrew ]]; then
  BREW_PREFIX="/opt/homebrew"
elif [[ -d /usr/local ]]; then
  BREW_PREFIX="/usr/local"
fi

if [[ -d "$BREW_PREFIX/share/zsh-completions" ]]; then
  fpath+="$BREW_PREFIX/share/zsh-completions"
fi

# Ensure fzf-tab installed
if [[ ! -d "$HOME/.zsh/fzf-tab" ]]; then
  git clone https://github.com/Aloxaf/fzf-tab "$HOME/.zsh/fzf-tab"
fi

# fzf-tab MUST load before compinit
if [[ -f "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "$HOME/.zsh/fzf-tab/fzf-tab.plugin.zsh"
fi

if [[ -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ -f "$BREW_PREFIX/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]]; then
  source "$BREW_PREFIX/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
fi

if [[ -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Initialize completions after fzf-tab
autoload -Uz compinit && compinit -u

# zoxide setup
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
  alias cdd='z -'
fi

##############################################################################
# Keybindings
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

##############################################################################
caff() {
  if pgrep -x caffeinate >/dev/null; then
    killall caffeinate
    echo "OFF"
  else
    caffeinate -di &
    echo "ON"
  fi
}

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
# Execution time tool
zmodload zsh/datetime

preexec() {
  timer=$EPOCHREALTIME
}

precmd() {
  if [[ -n $timer ]]; then
    local elapsed=$((EPOCHREALTIME - timer))
    printf 'Execution time: %.2fs\n' "$elapsed"
    unset timer
  fi
}

##############################################################################
# ALIASES
alias v='vim'
alias vv='vim --cmd "let g:vimrc_use_ai = 1"'
alias n='nvim'
alias nv='nvim'
alias lg='lazygit'
alias lzd='lazydocker'
alias c='clear'
alias python='python3'
alias history='history -30'
alias x='exit'

if command -v yazi &>/dev/null; then
  alias y='yazi'
fi

if command -v eza &>/dev/null; then
  alias ls='eza'
  alias ll='eza -lhg'
  alias lla='eza -alhg'
  alias tree='eza --tree'
else
  alias ls='ls --color'
  alias ll='ls -lh'
  alias lla='ls -alh'
fi

if command -v bat &>/dev/null; then
  alias cat='bat --paging=never --style=plain'
  alias catt='bat'
  alias cata='bat --show-all --paging=never --style=plain'
fi

if command -v btop &>/dev/null; then
  alias top='btop'
fi

if [[ -f "$HOME/dotfiles/zsh/git.sh" ]]; then
  source "$HOME/dotfiles/zsh/git.sh"
fi

if command -v fastfetch &>/dev/null; then
  alias ff='fastfetch'
  alias ffm='fastfetch --structure "Title:OS:Kernel:Uptime:CPU:CPU_cores:GPU:Memory:Resolution:Hostname:Shell:Packages:Disk:Battery" '
fi

if [[ -f "$HOME/dotfiles/zsh/aerospace.sh" ]]; then
  source "$HOME/dotfiles/zsh/aerospace.sh"
fi

##############################################################################
# Android SDK tools
if [[ -d "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home" ]]; then
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
fi

if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
fi

##############################################################################
# MySQL
if [[ -d "/opt/homebrew/opt/mysql-client/bin" ]]; then
  export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
fi

##############################################################################
# Ollama
export OLLAMA_CONTEXT_LENGTH=16384

##############################################################################
# Go bin path
if [[ -d "$HOME/go/bin" ]]; then
  export PATH="$PATH:$HOME/go/bin"
fi

##############################################################################
# Tmux Plugin Manager
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

##############################################################################
# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
