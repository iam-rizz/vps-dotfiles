#!/usr/bin/env bash
#
# link.sh - Create symlinks for dotfiles
# VPS Dotfiles

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}!${NC} $1"; }
print_info() { echo -e "${BLUE}→${NC} $1"; }

# Ensure directories exist
mkdir -p "$HOME/.config/btop/themes"
mkdir -p "$HOME/.config/fastfetch"
mkdir -p "$HOME/.config/nvim/lua"

# Define symlinks
declare -A symlinks=(
    ["$DOTFILES_DIR/config/zsh/.zshrc"]="$HOME/.zshrc"
    ["$DOTFILES_DIR/config/zsh/.zshenv"]="$HOME/.zshenv"
    ["$DOTFILES_DIR/config/bash/.bashrc"]="$HOME/.bashrc"
    ["$DOTFILES_DIR/config/bash/.bash_aliases"]="$HOME/.bash_aliases"
    ["$DOTFILES_DIR/config/starship/starship.toml"]="$HOME/.config/starship.toml"
    ["$DOTFILES_DIR/config/tmux/.tmux.conf"]="$HOME/.tmux.conf"
    ["$DOTFILES_DIR/config/btop/btop.conf"]="$HOME/.config/btop/btop.conf"
    ["$DOTFILES_DIR/config/fastfetch/config.jsonc"]="$HOME/.config/fastfetch/config.jsonc"
    ["$DOTFILES_DIR/config/fastfetch/config-full.jsonc"]="$HOME/.config/fastfetch/config-full.jsonc"
    ["$DOTFILES_DIR/config/nvim/init.lua"]="$HOME/.config/nvim/init.lua"
    ["$DOTFILES_DIR/config/git/.gitconfig"]="$HOME/.gitconfig"
    ["$DOTFILES_DIR/config/git/.gitignore"]="$HOME/.gitignore_global"
    ["$DOTFILES_DIR/config/lazygit/config.yml"]="$HOME/.config/lazygit/config.yml"
    ["$DOTFILES_DIR/config/lazydocker/config.yml"]="$HOME/.config/lazydocker/config.yml"
    ["$DOTFILES_DIR/themes/catppuccin/btop.theme"]="$HOME/.config/btop/themes/catppuccin_mocha.theme"
)

echo "Creating symlinks..."

for src in "${!symlinks[@]}"; do
    dest="${symlinks[$src]}"
    
    if [ -f "$src" ]; then
        # Remove existing file/symlink
        if [ -e "$dest" ] || [ -L "$dest" ]; then
            rm -f "$dest"
        fi
        
        # Create symlink
        ln -sf "$src" "$dest"
        print_success "Linked: $(basename "$dest")"
    else
        print_warning "Source not found: $src"
    fi
done

# Set secure permissions on source files (symlinks inherit target permissions)
chmod 600 "$DOTFILES_DIR/config/git/.gitconfig" 2>/dev/null || true
chmod 700 "$HOME/.config/btop" 2>/dev/null || true

print_success "All symlinks created!"
