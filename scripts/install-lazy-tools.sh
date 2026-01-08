#!/usr/bin/env bash
# install-lazy-tools.sh - Install lazygit and lazydocker
# VPS Dotfiles

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Installing Lazy Tools (lazygit & lazydocker)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="x86_64"
        ;;
    aarch64|arm64)
        ARCH="arm64"
        ;;
    armv7l)
        ARCH="armv7"
        ;;
    *)
        echo -e "${RED}✗ Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}→ Detected architecture: $ARCH${NC}"
echo

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Install lazygit
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Installing lazygit${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if command -v lazygit &> /dev/null; then
    CURRENT_VERSION=$(lazygit --version | grep -oP 'version=\K[0-9.]+' || echo "unknown")
    echo -e "${YELLOW}→ lazygit already installed (version: $CURRENT_VERSION)${NC}"
    read -p "Do you want to reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}→ Skipping lazygit installation${NC}"
        SKIP_LAZYGIT=true
    fi
fi

if [ "$SKIP_LAZYGIT" != "true" ]; then
    # Get latest version
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    echo -e "${BLUE}→ Latest version: $LAZYGIT_VERSION${NC}"
    
    # Download and install
    cd /tmp
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH}.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
    
    echo -e "${GREEN}✓ lazygit installed successfully${NC}"
    lazygit --version
fi

echo

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Install lazydocker
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Installing lazydocker${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if command -v lazydocker &> /dev/null; then
    CURRENT_VERSION=$(lazydocker --version | grep -oP 'Version: \K[0-9.]+' || echo "unknown")
    echo -e "${YELLOW}→ lazydocker already installed (version: $CURRENT_VERSION)${NC}"
    read -p "Do you want to reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}→ Skipping lazydocker installation${NC}"
        SKIP_LAZYDOCKER=true
    fi
fi

if [ "$SKIP_LAZYDOCKER" != "true" ]; then
    # Download and install using official script
    cd /tmp
    curl -s https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    
    echo -e "${GREEN}✓ lazydocker installed successfully${NC}"
    lazydocker --version
fi

echo
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${YELLOW}Usage:${NC}"
echo -e "  lazygit      - Git TUI (run in git repository)"
echo -e "  lazydocker   - Docker TUI"
echo
echo -e "${YELLOW}Aliases:${NC}"
echo -e "  lg           - lazygit"
echo -e "  lzd          - lazydocker"
echo
echo -e "${YELLOW}Config files:${NC}"
echo -e "  ~/.config/lazygit/config.yml"
echo -e "  ~/.config/lazydocker/config.yml"
echo
