#!/bin/bash
echo ">>> Setting up Zsh prompt and TERM..."

ZSHRC="$HOME/.zshrc"

# Make sure .zshrc exists
touch "$ZSHRC"

# 1. Fix Ghostty Terminal Issue
if ! grep -q "export TERM=xterm-256color" "$ZSHRC"; then
    echo "" >> "$ZSHRC"
    echo "# Fix for Ghostty terminal" >> "$ZSHRC"
    echo "export TERM=xterm-256color" >> "$ZSHRC"
    echo "✅ TERM variable set in Zsh."
else
    echo "⚡ TERM fix already in Zsh."
fi

# 2. Configure Custom Prompt
# Using Zsh color syntax (%F{green}...%f); %m = short hostname (portable)
ZSH_PROMPT='PROMPT="%F{green}me@%m%f:%F{blue}%~%f$ "'

if ! grep -q 'PROMPT="%F{green}me@' "$ZSHRC"; then
    echo "" >> "$ZSHRC"
    echo "# Custom Setup Prompt" >> "$ZSHRC"
    echo "$ZSH_PROMPT" >> "$ZSHRC"
    echo "✅ Prompt updated to me@<host> in Zsh."
else
    echo "⚡ Prompt already configured in Zsh."
fi
