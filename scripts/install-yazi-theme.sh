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
FLAVORS_DIR="$YAZI_CONFIG_DIR/flavors"

echo -e "${BLUE}→ Yazi config directory: $YAZI_CONFIG_DIR${NC}"

# Clean up old configs that might cause issues
echo -e "${BLUE}→ Cleaning up old configurations...${NC}"
rm -rf "$YAZI_CONFIG_DIR/init.lua" 2>/dev/null || true
rm -rf "$YAZI_CONFIG_DIR/plugins" 2>/dev/null || true
rm -rf "$FLAVORS_DIR" 2>/dev/null || true

# Create directories
mkdir -p "$FLAVORS_DIR"
echo -e "${GREEN}✓ Created config directories${NC}"

# Clone Catppuccin theme using ya pack (official method)
echo -e "${BLUE}→ Installing Catppuccin flavors via ya pack...${NC}"

# Install each flavor using ya pack
ya pack -a catppuccin/yazi:latte 2>/dev/null || {
    echo -e "${YELLOW}→ ya pack failed, using manual installation...${NC}"
    
    # Manual installation fallback
    cd /tmp
    rm -rf yazi-catppuccin
    git clone --quiet --depth 1 https://github.com/catppuccin/yazi.git yazi-catppuccin
    
    # Copy flavors in correct .yazi format
    for flavor in latte frappe macchiato mocha; do
        mkdir -p "$FLAVORS_DIR/${flavor}.yazi"
        # Find and copy the mauve accent theme as default for each flavor
        if [ -f "yazi-catppuccin/themes/${flavor}/catppuccin-${flavor}-mauve.toml" ]; then
            cp "yazi-catppuccin/themes/${flavor}/catppuccin-${flavor}-mauve.toml" "$FLAVORS_DIR/${flavor}.yazi/flavor.toml"
        fi
        # Also copy LICENSE if exists
        if [ -f "yazi-catppuccin/LICENSE" ]; then
            cp "yazi-catppuccin/LICENSE" "$FLAVORS_DIR/${flavor}.yazi/"
        fi
    done
    
    rm -rf yazi-catppuccin
}

# Try installing other flavors
ya pack -a catppuccin/yazi:frappe 2>/dev/null || true
ya pack -a catppuccin/yazi:macchiato 2>/dev/null || true
ya pack -a catppuccin/yazi:mocha 2>/dev/null || true

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

# List installed flavors
echo -e "${BLUE}→ Installed flavors:${NC}"
ls -d "$FLAVORS_DIR"/*.yazi 2>/dev/null | xargs -n1 basename | sed 's/.yazi$/  ✓ &/' || echo "  (none found)"

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
