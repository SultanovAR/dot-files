#!/bin/bash
echo ">>> Step 2: Downloading and Installing Tools (Dependencies & Neovim)..."

# 1. Install System Dependencies via APT
echo "Installing apt dependencies..."
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git curl wget tar unzip ripgrep fd-find build-essential fzf

# 2. Fix Ubuntu's weird naming for 'fd'
echo "Fixing 'fd' command..."
mkdir -p "$HOME/.local/bin"

# THE FIX IS HERE: Note the space after 'if' and before '['
if [ ! -f "$HOME/.local/bin/fd" ]; then
    ln -sf $(which fdfind) "$HOME/.local/bin/fd"
    echo "✅ Symlink created for fd."
else
    echo "⚡ fd is already linked."
fi

# Make sure it's in the PATH for this script session
export PATH="$HOME/.local/bin:$PATH"

# 3. Install Neovim (v0.10+)
if ! command -v nvim &> /dev/null; then
    echo "Installing Neovim from GitHub..."
    
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    
    sudo rm -rf /opt/nvim /opt/nvim-linux-x86_64
    
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    sudo mv /opt/nvim-linux-x86_64 /opt/nvim
    
    sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    sudo ln -sf /opt/nvim/bin/nvim /usr/bin/nvim
    
    rm nvim-linux-x86_64.tar.gz
    
    echo "✅ Neovim installed successfully."
else
    echo "⚡ Neovim is already installed."
    nvim --version | head -n 1
fi

echo ">>> Tools installation complete!"
