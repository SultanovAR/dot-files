#!/bin/bash

# Stop the script immediately if any command fails
set -e

echo "🚀 Starting Machine Setup..."

# 1. Make all your scripts executable so they can run
echo "Setting executable permissions..."
chmod +x download_tools.sh install_zsh.sh dotfiles.sh zsh_prompt.sh

# 2. Install core tools, dependencies, and Neovim
./download_tools.sh

# 3. Install Zsh, change default shell, and download plugins
./install_zsh.sh

# 4. Pull your personal configurations from GitHub
# (This happens before the prompt setup so it doesn't overwrite our prompt changes)
./dotfiles.sh

# 5. Apply the custom Zsh prompt (me@markov)
./zsh_prompt.sh

# (If you still have the uv or env scripts inside the 'scripts' folder, 
# you can uncomment the lines below to run them too)
# chmod +x scripts/*.sh
# ./scripts/03_load_env.sh
# ./scripts/04_install_uv.sh

echo ""
echo "🎉 Setup complete! 🎉"
echo "To see all your changes, please restart your terminal or type: exec zsh"
