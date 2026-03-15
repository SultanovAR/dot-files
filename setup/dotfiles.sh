#!/bin/bash
echo ">>> Step 4: Installing Dotfiles from GitHub (Atlassian Method)..."

REPO_URL="https://github.com/SultanovAR/dot-files.git"
CFG_DIR="$HOME/.cfg"

# 1. Clone the bare repository
if [ ! -d "$CFG_DIR" ]; then
    echo "Cloning bare repository into $CFG_DIR..."
    git clone --bare "$REPO_URL" "$CFG_DIR"
else
    echo "⚡ Bare repository already exists at $CFG_DIR."
fi

# 2. Define the 'config' command as a function for this script
function config {
   /usr/bin/git --git-dir="$CFG_DIR/" --work-tree="$HOME" "$@"
}

# 3. Create a backup folder for conflicting files
mkdir -p "$HOME/.config-backup"

# 4. Attempt to checkout the dotfiles
echo "Checking out dotfiles..."

# We try to checkout. If it fails, it means files like .zshrc already exist.
if config checkout 2>/dev/null; then
    echo "✅ Checked out config without conflicts."
else
    echo "⚠️ Conflicts detected. Backing up pre-existing dotfiles..."
    
    # This reads the Git error, finds the conflicting files, and moves them to the backup folder
    config checkout 2>&1 | grep -E "^\s+[.]" | awk '{print $1}' | while read -r file; do
        echo "Backing up: $file"
        # Make sure the target directory exists in the backup folder (e.g., for .config/nvim)
        mkdir -p "$HOME/.config-backup/$(dirname "$file")"
        mv "$HOME/$file" "$HOME/.config-backup/$file" 2>/dev/null || true
    done
    
    # Try the checkout again after moving the blockers
    if config checkout; then
        echo "✅ Checked out config after backing up old files."
    else
        echo "❌ Standard checkout failed. Forcing checkout..."
        config checkout -f
    fi
fi

# 5. Set the local config to hide untracked files (so 'config status' doesn't show your whole hard drive)
config config --local status.showUntrackedFiles no

# 6. Add the alias to your shell configs so you can use 'config add', 'config commit', etc.
ALIAS_CMD="alias config='/usr/bin/git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME'"

# Append to Bash
if [ -f "$HOME/.bashrc" ]; then
    if ! grep -q "alias config=" "$HOME/.bashrc"; then
        echo "" >> "$HOME/.bashrc"
        echo "# Atlassian Dotfiles Alias" >> "$HOME/.bashrc"
        echo "$ALIAS_CMD" >> "$HOME/.bashrc"
    fi
fi

# Append to Zsh
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "alias config=" "$HOME/.zshrc"; then
        echo "" >> "$HOME/.zshrc"
        echo "# Atlassian Dotfiles Alias" >> "$HOME/.zshrc"
        echo "$ALIAS_CMD" >> "$HOME/.zshrc"
    fi
fi

echo ">>> Dotfiles setup complete!"
