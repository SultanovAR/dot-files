. "$HOME/.local/bin/env"

export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="$HOME/Library/Python/3.13/bin:$PATH"
export PATH="$HOME/.pixi/bin:$PATH"

alias config='/usr/bin/git --git-dir=$HOME/.store_configs/ --work-tree=$HOME'

# zsh-vi-mode clobbers any zle widgets bound BEFORE it loads.
# ZVM_INIT_MODE=sourcing makes zvm init at source-time (top scope) instead of
# inside a precmd function. Without this, sourcing autosuggestions from
# zvm_after_init runs in zvm's local scope where `local commands` shadows
# the `zsh/parameter` `commands` assoc -> add-zle-hook-widget breaks.
ZVM_INIT_MODE=sourcing
source "$HOME/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Fix for Ghostty terminal
export TERM=xterm-256color

# Prompt
PROMPT="%F{green}me@%m%f:%F{blue}%~%f$ "

# Secrets (gitignored, chmod 600)
[ -f "$HOME/.config/zsh/secrets.zsh" ] && source "$HOME/.config/zsh/secrets.zsh"
