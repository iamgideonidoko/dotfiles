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
alias ll='ls -lh'
alias lla='ls -alh'
alias python='python3'
# Shows the last 30 entries, default is 15
alias history='history -30'
alias x='exit'
alias chrome="open -a 'Google Chrome'"
##############################################################################
