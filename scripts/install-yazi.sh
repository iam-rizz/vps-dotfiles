#!/usr/bin/env bash
# install-yazi.sh - Install yazi terminal file manager
# VPS Dotfiles

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Installing Yazi Terminal File Manager${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="x86_64"
        ;;
    aarch64|arm64)
        ARCH="aarch64"
        ;;
    *)
        echo -e "${RED}✗ Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}→ Detected architecture: $ARCH${NC}"

# Check if yazi is already installed
if command -v yazi &> /dev/null; then
    CURRENT_VERSION=$(yazi --version | grep -oP 'Yazi \K[0-9.]+' || echo "unknown")
    echo -e "${YELLOW}→ Yazi already installed (version: $CURRENT_VERSION)${NC}"
    read -p "Do you want to reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}→ Skipping yazi installation${NC}"
        exit 0
    fi
fi

# Get latest version
echo -e "${BLUE}→ Fetching latest version...${NC}"
YAZI_VERSION=$(curl -s "https://api.github.com/repos/sxyazi/yazi/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
echo -e "${BLUE}→ Latest version: $YAZI_VERSION${NC}"

# Download and install
echo -e "${BLUE}→ Downloading yazi...${NC}"
cd /tmp
curl -Lo yazi.zip "https://github.com/sxyazi/yazi/releases/download/v${YAZI_VERSION}/yazi-${ARCH}-unknown-linux-gnu.zip"

echo -e "${BLUE}→ Extracting...${NC}"
unzip -q yazi.zip

echo -e "${BLUE}→ Installing to /usr/local/bin...${NC}"
sudo install "yazi-${ARCH}-unknown-linux-gnu/yazi" /usr/local/bin/yazi
sudo install "yazi-${ARCH}-unknown-linux-gnu/ya" /usr/local/bin/ya

# Cleanup
rm -rf yazi.zip "yazi-${ARCH}-unknown-linux-gnu"

echo -e "${GREEN}✓ Yazi installed successfully${NC}"
yazi --version

echo
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${YELLOW}Usage:${NC}"
echo -e "  yazi             - Launch yazi file manager"
echo -e "  yazi <path>      - Open specific directory"
echo ""
echo -e "${YELLOW}Aliases:${NC}"
echo -e "  y                - yazi"
echo -e "  fm               - yazi (file manager)"
echo
echo -e "${YELLOW}Config:${NC}"
echo -e "  ~/.config/yazi/"
echo
echo -e "${YELLOW}Next step:${NC}"
echo -e "  Run: ${GREEN}~/.dotfiles/scripts/install-yazi-theme.sh${NC}"
echo -e "  To install Catppuccin theme"
echo
