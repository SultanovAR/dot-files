export PATH="$HOME/.emacs.d/bin:$PATH"

. "$HOME/.local/bin/env"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="$HOME/Library/Python/3.13/bin:$PATH"
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
alias config='/usr/bin/git --git-dir=$HOME/.store_configs/ --work-tree=$HOME'
