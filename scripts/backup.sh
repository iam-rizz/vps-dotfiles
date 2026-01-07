#!/usr/bin/env bash
#
# backup.sh - Backup existing configurations
# VPS Dotfiles

set -e

BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}!${NC} $1"; }
print_info() { echo -e "${BLUE}→${NC} $1"; }

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Backing Up Configurations"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Files to backup
files_to_backup=(
    "$HOME/.zshrc"
    "$HOME/.zshenv"
    "$HOME/.bashrc"
    "$HOME/.bash_aliases"
    "$HOME/.tmux.conf"
    "$HOME/.gitconfig"
    "$HOME/.config/starship.toml"
    "$HOME/.config/btop/btop.conf"
    "$HOME/.config/fastfetch/config.jsonc"
    "$HOME/.config/nvim/init.lua"
)

backed_up=0

for file in "${files_to_backup[@]}"; do
    if [ -f "$file" ] || [ -L "$file" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "${file#$HOME/}")"
        cp -P "$file" "$BACKUP_DIR/${file#$HOME/}" 2>/dev/null || true
        print_info "Backed up: $file"
        ((backed_up++))
    fi
done

if [ $backed_up -gt 0 ]; then
    print_success "Backed up $backed_up files to $BACKUP_DIR"
else
    print_info "No existing configs to backup"
fi
