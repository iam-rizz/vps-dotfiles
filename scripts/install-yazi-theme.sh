#!/usr/bin/env bash
# install-yazi-theme.sh - Install Catppuccin theme for yazi
# VPS Dotfiles
# Based on official catppuccin/yazi installation method

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
THEMES_DIR="$YAZI_CONFIG_DIR/themes"

echo -e "${BLUE}→ Yazi config directory: $YAZI_CONFIG_DIR${NC}"

# Clean up old configs that might cause issues
echo -e "${BLUE}→ Cleaning up old configurations...${NC}"
rm -rf "$YAZI_CONFIG_DIR/init.lua" 2>/dev/null || true
rm -rf "$YAZI_CONFIG_DIR/plugins" 2>/dev/null || true
rm -rf "$YAZI_CONFIG_DIR/flavors" 2>/dev/null || true

# Create directories
mkdir -p "$THEMES_DIR"
mkdir -p "$YAZI_CONFIG_DIR"
echo -e "${GREEN}✓ Created config directories${NC}"

# Clone Catppuccin theme (official method: copy theme.toml directly)
echo -e "${BLUE}→ Downloading Catppuccin themes...${NC}"
cd /tmp
rm -rf yazi-catppuccin
git clone --quiet --depth 1 https://github.com/catppuccin/yazi.git yazi-catppuccin

# Copy all theme files to themes directory
echo -e "${BLUE}→ Installing theme files...${NC}"
cp yazi-catppuccin/themes/catppuccin-*.toml "$THEMES_DIR/"

# Cleanup
rm -rf yazi-catppuccin

echo -e "${GREEN}✓ Catppuccin themes installed${NC}"

# Set default theme (Macchiato with mauve accent)
echo -e "${BLUE}→ Setting default theme (Macchiato)...${NC}"
cp "$THEMES_DIR/catppuccin-macchiato-mauve.toml" "$YAZI_CONFIG_DIR/theme.toml"

echo -e "${GREEN}✓ Default theme configured${NC}"

# List installed themes
echo -e "${BLUE}→ Installed themes:${NC}"
ls "$THEMES_DIR"/*.toml 2>/dev/null | xargs -n1 basename | sed 's/^/  ✓ /' || echo "  (none found)"

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
echo -e "  yazi_theme mocha"
echo -e "  yazi_theme latte"
echo
echo -e "${YELLOW}Test yazi:${NC}"
echo -e "  yazi"
echo
