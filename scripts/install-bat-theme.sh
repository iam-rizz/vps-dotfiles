#!/usr/bin/env bash
# install-bat-theme.sh - Install Catppuccin theme for bat
# VPS Dotfiles

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Installing Catppuccin Theme for Bat${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Check if bat is installed
if ! command -v bat &> /dev/null && ! command -v batcat &> /dev/null; then
    echo -e "${RED}✗ bat is not installed${NC}"
    echo -e "${YELLOW}  Install bat first: sudo apt install bat${NC}"
    exit 1
fi

# Determine bat command
BAT_CMD="bat"
if command -v batcat &> /dev/null; then
    BAT_CMD="batcat"
fi

echo -e "${GREEN}✓ Found bat: $BAT_CMD${NC}"

# Get bat config directory
BAT_CONFIG_DIR="$($BAT_CMD --config-dir)"
THEMES_DIR="$BAT_CONFIG_DIR/themes"

echo -e "${BLUE}→ Bat config directory: $BAT_CONFIG_DIR${NC}"

# Create themes directory
mkdir -p "$THEMES_DIR"
echo -e "${GREEN}✓ Created themes directory${NC}"

# Download Catppuccin themes
echo -e "${BLUE}→ Downloading Catppuccin themes...${NC}"

cd "$THEMES_DIR"

# Download all Catppuccin variants
curl -fsSL https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-latte.tmTheme -o Catppuccin-latte.tmTheme
curl -fsSL https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-frappe.tmTheme -o Catppuccin-frappe.tmTheme
curl -fsSL https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-macchiato.tmTheme -o Catppuccin-macchiato.tmTheme
curl -fsSL https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme -o Catppuccin-mocha.tmTheme

echo -e "${GREEN}✓ Downloaded Catppuccin themes${NC}"

# Rebuild bat cache
echo -e "${BLUE}→ Rebuilding bat cache...${NC}"
$BAT_CMD cache --build

echo -e "${GREEN}✓ Bat cache rebuilt${NC}"
echo
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Catppuccin theme installed successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${YELLOW}Available themes:${NC}"
echo -e "  - Catppuccin-latte"
echo -e "  - Catppuccin-frappe"
echo -e "  - Catppuccin-macchiato"
echo -e "  - Catppuccin-mocha (default in .zshrc)"
echo
echo -e "${YELLOW}Test the theme:${NC}"
echo -e "  $BAT_CMD --theme=Catppuccin-mocha ~/.zshrc"
echo
echo -e "${YELLOW}List all themes:${NC}"
echo -e "  $BAT_CMD --list-themes"
echo
