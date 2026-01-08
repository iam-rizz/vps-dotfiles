#!/usr/bin/env bash
# install-lazygit-themes.sh - Install Catppuccin themes for lazygit
# VPS Dotfiles

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Installing Catppuccin Themes for Lazygit${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Check if lazygit is installed
if ! command -v lazygit &> /dev/null; then
    echo -e "${RED}✗ lazygit is not installed${NC}"
    echo -e "${YELLOW}  Install lazygit first: ~/.dotfiles/scripts/install-lazy-tools.sh${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Found lazygit${NC}"

# Get lazygit config directory
LAZYGIT_CONFIG_DIR="$HOME/.config/lazygit"
THEMES_DIR="$LAZYGIT_CONFIG_DIR/themes"

echo -e "${BLUE}→ Lazygit config directory: $LAZYGIT_CONFIG_DIR${NC}"

# Create themes directory
mkdir -p "$THEMES_DIR"
echo -e "${GREEN}✓ Created themes directory${NC}"

# Download Catppuccin themes
echo -e "${BLUE}→ Downloading Catppuccin themes...${NC}"

# Base URL
BASE_URL="https://raw.githubusercontent.com/catppuccin/lazygit/main/themes"

# Download all variants (blue accent)
echo -e "${BLUE}  → Latte (light)...${NC}"
curl -fsSL "$BASE_URL/latte/blue.yml" -o "$THEMES_DIR/catppuccin-latte.yml"

echo -e "${BLUE}  → Frappe (dark warm)...${NC}"
curl -fsSL "$BASE_URL/frappe/blue.yml" -o "$THEMES_DIR/catppuccin-frappe.yml"

echo -e "${BLUE}  → Macchiato (dark cool)...${NC}"
curl -fsSL "$BASE_URL/macchiato/blue.yml" -o "$THEMES_DIR/catppuccin-macchiato.yml"

echo -e "${BLUE}  → Mocha (dark)...${NC}"
curl -fsSL "$BASE_URL/mocha/blue.yml" -o "$THEMES_DIR/catppuccin-mocha.yml"

echo -e "${GREEN}✓ Downloaded all Catppuccin themes${NC}"

# Set default theme to Macchiato
echo -e "${BLUE}→ Setting default theme to Macchiato...${NC}"

# Create or update config.yml with theme include
if [ ! -f "$LAZYGIT_CONFIG_DIR/config.yml" ]; then
    # Create new config with theme
    cat > "$LAZYGIT_CONFIG_DIR/config.yml" << 'EOF'
# lazygit config - Catppuccin Theme
# VPS Dotfiles

# Include theme (change this line to switch themes)
# Available: catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
theme:
  include:
    - "{{ .UserConfigDir }}/themes/catppuccin-macchiato.yml"

gui:
  showFileTree: true
  showRandomTip: false
  showCommandLog: false
  nerdFontsVersion: "3"
  border: rounded
  windowSize: normal
  commitLength:
    show: true

git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
  autoFetch: true
  autoRefresh: true
  branchLogCmd: git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --

refresher:
  refreshInterval: 10
  fetchInterval: 60

update:
  method: never

notARepository: 'skip'
EOF
    echo -e "${GREEN}✓ Created config.yml with Macchiato theme${NC}"
else
    echo -e "${YELLOW}→ config.yml already exists, skipping...${NC}"
    echo -e "${YELLOW}  To use themes, add this to your config.yml:${NC}"
    echo -e "${YELLOW}  theme:${NC}"
    echo -e "${YELLOW}    include:${NC}"
    echo -e "${YELLOW}      - \"{{ .UserConfigDir }}/themes/catppuccin-macchiato.yml\"${NC}"
fi

echo
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Catppuccin themes installed successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${YELLOW}Available themes:${NC}"
echo -e "  - catppuccin-latte      (light)"
echo -e "  - catppuccin-frappe     (dark warm)"
echo -e "  - catppuccin-macchiato  (dark cool, default)"
echo -e "  - catppuccin-mocha      (dark)"
echo
echo -e "${YELLOW}Switch theme:${NC}"
echo -e "  lazygit_theme latte|frappe|macchiato|mocha"
echo
echo -e "${YELLOW}Theme files location:${NC}"
echo -e "  $THEMES_DIR/"
echo
