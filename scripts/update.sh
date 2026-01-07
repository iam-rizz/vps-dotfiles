#!/usr/bin/env bash
#
# update.sh - Update dotfiles from git
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

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Updating VPS Dotfiles"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cd "$DOTFILES_DIR"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    print_warning "You have uncommitted changes"
    read -p "Stash changes and continue? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git stash
        print_info "Changes stashed"
    else
        print_warning "Update cancelled"
        exit 1
    fi
fi

# Pull latest changes
print_info "Pulling latest changes..."
git pull

# Re-run link script
print_info "Re-creating symlinks..."
bash "$DOTFILES_DIR/scripts/link.sh"

# Update state file
if [ -f "$DOTFILES_DIR/.state" ]; then
    sed -i "s/LAST_UPDATE=.*/LAST_UPDATE=\"$(date +%Y-%m-%d)\"/" "$DOTFILES_DIR/.state"
fi

print_success "Dotfiles updated successfully!"
echo ""
echo "Run 'source ~/.zshrc' or 'source ~/.bashrc' to apply changes"
