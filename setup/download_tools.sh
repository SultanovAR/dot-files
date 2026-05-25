#!/bin/bash
# Install dev tools into ~/opt and symlink binaries into ~/.local/bin.
# Survives non-home wipes. Re-runnable.
set -euo pipefail

echo ">>> Step 2: Installing tools into ~/opt + ~/.local/bin..."

OPT="$HOME/opt"
BIN="$HOME/.local/bin"
mkdir -p "$OPT" "$BIN"
export PATH="$BIN:$PATH"

OS_RAW="$(uname -s)"
ARCH_RAW="$(uname -m)"

case "$OS_RAW" in
    Linux)  OS=linux  ;;
    Darwin) OS=darwin ;;
    *) echo "Unsupported OS: $OS_RAW" >&2; exit 1 ;;
esac
case "$ARCH_RAW" in
    x86_64|amd64)   ARCH=x86_64;  ARCH_ALT=amd64;  ARCH_GNU=x86_64 ;;
    aarch64|arm64)  ARCH=aarch64; ARCH_ALT=arm64;  ARCH_GNU=aarch64 ;;
    *) echo "Unsupported arch: $ARCH_RAW" >&2; exit 1 ;;
esac

echo "Detected: $OS/$ARCH"

# Bootstrap deps. On Linux: apt for git/curl/tar/etc (needed to fetch user-local binaries).
# On macOS: assume Xcode CLT / brew already provide curl/tar/git.
if [ "$OS" = linux ] && command -v apt-get >/dev/null 2>&1; then
    echo "Installing apt bootstrap deps..."
    sudo apt-get update -y
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git curl wget tar unzip build-essential ca-certificates
fi

# Resolve latest GitHub release tag without hitting the API (no rate limit).
# Reads the redirect from /releases/latest to /releases/tag/<TAG>.
latest_tag() {
    local repo="$1"
    curl -fsSI "https://github.com/$repo/releases/latest" \
        | tr -d '\r' \
        | awk -F'/' '/^[Ll]ocation:/ {print $NF}' \
        | tail -n1
}

# Download tarball, extract into $OPT/<name>, symlink binary.
# args: name, url, bin_subpath_inside_extracted_root
install_tarball() {
    local name="$1" url="$2" bin_subpath="$3"
    local dest="$OPT/$name"
    echo "→ $name: $url"
    local tmp; tmp="$(mktemp -t "${name}.XXXXXX.tar.gz")"
    curl -fL -o "$tmp" "$url"
    rm -rf "$dest"
    mkdir -p "$dest"
    tar -C "$dest" --strip-components=1 -xzf "$tmp"
    rm -f "$tmp"
    ln -sf "$dest/$bin_subpath" "$BIN/$(basename "$bin_subpath")"
    echo "✅ $name → $dest, linked $BIN/$(basename "$bin_subpath")"
}

# --- ripgrep ---------------------------------------------------------------
if ! command -v rg >/dev/null 2>&1; then
    RG_TAG="$(latest_tag BurntSushi/ripgrep)"
    case "$OS/$ARCH" in
        linux/x86_64)   RG_TRIPLE="x86_64-unknown-linux-musl" ;;
        linux/aarch64)  RG_TRIPLE="aarch64-unknown-linux-gnu" ;;
        darwin/x86_64)  RG_TRIPLE="x86_64-apple-darwin" ;;
        darwin/aarch64) RG_TRIPLE="aarch64-apple-darwin" ;;
    esac
    install_tarball ripgrep \
        "https://github.com/BurntSushi/ripgrep/releases/download/${RG_TAG}/ripgrep-${RG_TAG}-${RG_TRIPLE}.tar.gz" \
        rg
else
    echo "⚡ ripgrep already installed: $(rg --version | head -n1)"
fi

# --- fd --------------------------------------------------------------------
if ! command -v fd >/dev/null 2>&1; then
    FD_TAG="$(latest_tag sharkdp/fd)"
    case "$OS/$ARCH" in
        linux/x86_64)   FD_TRIPLE="x86_64-unknown-linux-musl" ;;
        linux/aarch64)  FD_TRIPLE="aarch64-unknown-linux-musl" ;;
        darwin/x86_64)  FD_TRIPLE="x86_64-apple-darwin" ;;
        darwin/aarch64) FD_TRIPLE="aarch64-apple-darwin" ;;
    esac
    install_tarball fd \
        "https://github.com/sharkdp/fd/releases/download/${FD_TAG}/fd-${FD_TAG}-${FD_TRIPLE}.tar.gz" \
        fd
else
    echo "⚡ fd already installed: $(fd --version)"
fi

# --- fzf -------------------------------------------------------------------
if ! command -v fzf >/dev/null 2>&1; then
    FZF_TAG="$(latest_tag junegunn/fzf)"
    FZF_VER="${FZF_TAG#v}"
    case "$OS/$ARCH" in
        linux/x86_64)   FZF_PLAT="linux_amd64" ;;
        linux/aarch64)  FZF_PLAT="linux_arm64" ;;
        darwin/x86_64)  FZF_PLAT="darwin_amd64" ;;
        darwin/aarch64) FZF_PLAT="darwin_arm64" ;;
    esac
    # fzf ships a single-binary tarball; install into ~/opt/fzf manually.
    FZF_DEST="$OPT/fzf"
    echo "→ fzf: ${FZF_TAG} ${FZF_PLAT}"
    tmp="$(mktemp -t fzf.XXXXXX.tar.gz)"
    curl -fL -o "$tmp" "https://github.com/junegunn/fzf/releases/download/${FZF_TAG}/fzf-${FZF_VER}-${FZF_PLAT}.tar.gz"
    rm -rf "$FZF_DEST"; mkdir -p "$FZF_DEST"
    tar -C "$FZF_DEST" -xzf "$tmp"
    rm -f "$tmp"
    ln -sf "$FZF_DEST/fzf" "$BIN/fzf"
    echo "✅ fzf → $FZF_DEST, linked $BIN/fzf"
else
    echo "⚡ fzf already installed: $(fzf --version)"
fi

# --- Neovim ----------------------------------------------------------------
NVIM_DIR="$OPT/nvim"
if ! command -v nvim >/dev/null 2>&1 || [ ! -x "$NVIM_DIR/bin/nvim" ]; then
    case "$OS/$ARCH" in
        linux/x86_64)   NVIM_ASSET="nvim-linux-x86_64.tar.gz" ;;
        linux/aarch64)  NVIM_ASSET="nvim-linux-arm64.tar.gz" ;;
        darwin/x86_64)  NVIM_ASSET="nvim-macos-x86_64.tar.gz" ;;
        darwin/aarch64) NVIM_ASSET="nvim-macos-arm64.tar.gz" ;;
    esac
    install_tarball nvim \
        "https://github.com/neovim/neovim/releases/latest/download/${NVIM_ASSET}" \
        bin/nvim
else
    echo "⚡ Neovim already installed: $(nvim --version | head -n1)"
fi

echo ">>> Tools installation complete!"
echo "Make sure \$HOME/.local/bin is on PATH (the merged .zshrc handles this via ~/.local/bin/env)."
