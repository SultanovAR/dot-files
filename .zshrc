. "$HOME/.local/bin/env"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="$HOME/Library/Python/3.13/bin:$PATH"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Load Zsh Plugins
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# Fix for Ghostty terminal
export TERM=xterm-256color

# Custom Setup Prompt
PROMPT="%F{green}me@markov%f:%F{blue}%~%f$ "
