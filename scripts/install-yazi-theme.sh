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
rm -rf "$THEMES_DIR" 2>/dev/null || true

# Create directories
mkdir -p "$THEMES_DIR"
echo -e "${GREEN}✓ Created config directories${NC}"

# Clone Catppuccin theme
echo -e "${BLUE}→ Downloading Catppuccin themes...${NC}"
rm -rf /tmp/yazi-catppuccin
git clone --quiet --depth 1 https://github.com/catppuccin/yazi.git /tmp/yazi-catppuccin

# Copy theme files from each flavor subfolder
# Structure: themes/{flavor}/catppuccin-{flavor}-{accent}.toml
echo -e "${BLUE}→ Installing theme files...${NC}"
for flavor in latte frappe macchiato mocha; do
    if [ -d "/tmp/yazi-catppuccin/themes/$flavor" ]; then
        cp /tmp/yazi-catppuccin/themes/$flavor/*.toml "$THEMES_DIR/"
        echo -e "${GREEN}  ✓ $flavor themes installed${NC}"
    fi
done

# Cleanup
rm -rf /tmp/yazi-catppuccin

echo -e "${GREEN}✓ Catppuccin themes installed${NC}"

# Set default theme (Macchiato with mauve accent)
echo -e "${BLUE}→ Setting default theme (Macchiato)...${NC}"
if [ -f "$THEMES_DIR/catppuccin-macchiato-mauve.toml" ]; then
    cp "$THEMES_DIR/catppuccin-macchiato-mauve.toml" "$YAZI_CONFIG_DIR/theme.toml"
    echo -e "${GREEN}✓ Default theme configured${NC}"
else
    echo -e "${RED}✗ Default theme file not found${NC}"
fi

# Count installed themes
THEME_COUNT=$(ls "$THEMES_DIR"/*.toml 2>/dev/null | wc -l)
echo -e "${BLUE}→ Installed $THEME_COUNT theme files${NC}"

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
