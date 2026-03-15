#!/bin/bash
echo ">>> Step 3: Installing Zsh and Plugins..."

# 1. Install Zsh
if ! command -v zsh &> /dev/null; then
    echo "Installing Zsh..."
    sudo apt-get update -y
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y zsh
    echo "✅ Zsh installed."
else
    echo "⚡ Zsh is already installed."
fi

# 2. Change default shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to Zsh..."
    sudo chsh -s "$(which zsh)" "$USER"
    echo "✅ Default shell changed to Zsh (requires logout/login to take effect)."
fi

# 3. Create a directory for our plugins
ZSH_PLUGIN_DIR="$HOME/.zsh"
mkdir -p "$ZSH_PLUGIN_DIR"

# 4. Clone the plugins
echo "Installing Zsh plugins..."

if [ ! -d "$ZSH_PLUGIN_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGIN_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_PLUGIN_DIR/zsh-vi-mode" ]; then
    git clone https://github.com/jeffreytse/zsh-vi-mode.git "$ZSH_PLUGIN_DIR/zsh-vi-mode"
fi
echo "✅ Plugins downloaded."

# 5. Ensure .zshrc actually exists
touch "$HOME/.zshrc"

# 6. Add plugins to .zshrc safely
if ! grep -q "zsh-autosuggestions.zsh" "$HOME/.zshrc"; then
    echo "" >> "$HOME/.zshrc"
    echo "# Load Zsh Plugins" >> "$HOME/.zshrc"
    echo 'source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"' >> "$HOME/.zshrc"
    echo 'source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"' >> "$HOME/.zshrc"
    echo 'source "$HOME/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh"' >> "$HOME/.zshrc"
    echo "✅ Plugins added to .zshrc."
else
    echo "⚡ Plugins already configured in .zshrc."
fi

echo ">>> Zsh setup complete!"

