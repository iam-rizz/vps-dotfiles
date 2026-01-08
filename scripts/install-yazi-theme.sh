#!/usr/bin/env bash
# install-yazi-theme.sh - Install Catppuccin theme for yazi
# VPS Dotfiles

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Installing Catppuccin Theme for Yazi${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Check if yazi is installed
if ! command -v yazi &> /dev/null; then
    echo -e "${RED}✗ Yazi is not installed${NC}"
    echo -e "${YELLOW}  Install yazi first: ~/.dotfiles/scripts/install-yazi.sh${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Found yazi${NC}"

# Yazi config directory
YAZI_CONFIG_DIR="$HOME/.config/yazi"
THEMES_DIR="$YAZI_CONFIG_DIR/flavors"

echo -e "${BLUE}→ Yazi config directory: $YAZI_CONFIG_DIR${NC}"

# Create directories
mkdir -p "$THEMES_DIR"
mkdir -p "$YAZI_CONFIG_DIR"
echo -e "${GREEN}✓ Created config directories${NC}"

# Clone Catppuccin theme
echo -e "${BLUE}→ Cloning Catppuccin theme repository...${NC}"
cd /tmp
rm -rf yazi-catppuccin
git clone --quiet https://github.com/catppuccin/yazi.git yazi-catppuccin

# Copy all flavors
echo -e "${BLUE}→ Installing theme flavors...${NC}"
cp -r yazi-catppuccin/themes/* "$THEMES_DIR/"

# Cleanup
rm -rf yazi-catppuccin

echo -e "${GREEN}✓ Catppuccin themes installed${NC}"

# Create or update theme.toml
echo -e "${BLUE}→ Configuring default theme (Macchiato)...${NC}"

cat > "$YAZI_CONFIG_DIR/theme.toml" << 'EOF'
# Yazi theme configuration
# VPS Dotfiles - Catppuccin Macchiato

# Use Catppuccin Macchiato flavor
[flavor]
use = "macchiato"
EOF

echo -e "${GREEN}✓ Theme configuration created${NC}"

echo
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Catppuccin theme installed successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${YELLOW}Available flavors:${NC}"
echo -e "  - latte      (light)"
echo -e "  - frappe     (dark warm)"
echo -e "  - macchiato  (dark cool, default)"
echo -e "  - mocha      (dark)"
echo
echo -e "${YELLOW}Switch theme:${NC}"
echo -e "  Edit ~/.config/yazi/theme.toml"
echo -e "  Change 'use = \"macchiato\"' to your preferred flavor"
echo
echo -e "${YELLOW}Test yazi:${NC}"
echo -e "  yazi"
echo
