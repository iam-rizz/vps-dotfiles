#!/usr/bin/env bash
#
# VPS Dotfiles Uninstall Script
# Removes dotfiles configurations and optionally restores backups
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="$DOTFILES_DIR/.state"

# Print functions
print_header() {
    echo -e "\n${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}!${NC} $1"; }
print_info() { echo -e "${BLUE}→${NC} $1"; }

# Check if command exists
cmd_exists() {
    command -v "$1" &> /dev/null
}

# Show usage
show_usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --all             Remove everything (configs, themes, tools)"
    echo "  --configs         Remove config symlinks only"
    echo "  --themes          Remove installed themes only"
    echo "  --tools           Remove installed tools (lazygit, lazydocker, yazi)"
    echo "  --restore         Restore from backup after uninstall"
    echo "  --keep-shell      Don't change default shell back to bash"
    echo "  --dry-run         Show what would be removed without removing"
    echo "  --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --all              # Remove everything"
    echo "  $0 --configs          # Remove only config symlinks"
    echo "  $0 --all --restore    # Remove all and restore backup"
}

# Remove symlinks created by dotfiles
remove_symlinks() {
    print_header "Removing Config Symlinks"
    
    local symlinks=(
        "$HOME/.zshrc"
        "$HOME/.zshenv"
        "$HOME/.bashrc"
        "$HOME/.bash_aliases"
        "$HOME/.tmux.conf"
        "$HOME/.gitconfig"
        "$HOME/.gitignore_global"
        "$HOME/.config/starship.toml"
        "$HOME/.config/btop/btop.conf"
        "$HOME/.config/btop/themes/catppuccin_mocha.theme"
        "$HOME/.config/fastfetch/config.jsonc"
        "$HOME/.config/fastfetch/config-full.jsonc"
        "$HOME/.config/nvim/init.lua"
        "$HOME/.config/lazygit/config.yml"
        "$HOME/.config/lazydocker/config.yml"
    )
    
    for link in "${symlinks[@]}"; do
        if [ -L "$link" ]; then
            if $DRY_RUN; then
                print_info "[DRY-RUN] Would remove symlink: $link"
            else
                rm -f "$link"
                print_success "Removed symlink: $link"
            fi
        elif [ -f "$link" ]; then
            print_warning "Not a symlink (skipped): $link"
        fi
    done
}

# Remove bat themes
remove_bat_themes() {
    print_header "Removing Bat Themes"
    
    local BAT_CMD="bat"
    if cmd_exists batcat; then
        BAT_CMD="batcat"
    fi
    
    if cmd_exists $BAT_CMD; then
        local BAT_CONFIG_DIR="$($BAT_CMD --config-dir)"
        local THEMES_DIR="$BAT_CONFIG_DIR/themes"
        
        if [ -d "$THEMES_DIR" ]; then
            local themes=(
                "Catppuccin Latte.tmTheme"
                "Catppuccin Frappe.tmTheme"
                "Catppuccin Macchiato.tmTheme"
                "Catppuccin Mocha.tmTheme"
            )
            
            for theme in "${themes[@]}"; do
                if [ -f "$THEMES_DIR/$theme" ]; then
                    if $DRY_RUN; then
                        print_info "[DRY-RUN] Would remove: $THEMES_DIR/$theme"
                    else
                        rm -f "$THEMES_DIR/$theme"
                        print_success "Removed: $theme"
                    fi
                fi
            done
            
            # Rebuild bat cache
            if ! $DRY_RUN; then
                $BAT_CMD cache --build 2>/dev/null || true
                print_success "Rebuilt bat cache"
            fi
        fi
    else
        print_warning "Bat not installed, skipping theme removal"
    fi
}

# Remove lazygit themes
remove_lazygit_themes() {
    print_header "Removing Lazygit Themes"
    
    local THEMES_DIR="$HOME/.config/lazygit/themes"
    
    if [ -d "$THEMES_DIR" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would remove: $THEMES_DIR"
        else
            rm -rf "$THEMES_DIR"
            print_success "Removed lazygit themes directory"
        fi
    else
        print_info "Lazygit themes directory not found"
    fi
}

# Remove yazi themes and config
remove_yazi_config() {
    print_header "Removing Yazi Configuration"
    
    local YAZI_CONFIG_DIR="$HOME/.config/yazi"
    
    if [ -d "$YAZI_CONFIG_DIR" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would remove: $YAZI_CONFIG_DIR"
        else
            rm -rf "$YAZI_CONFIG_DIR"
            print_success "Removed yazi config directory"
        fi
    else
        print_info "Yazi config directory not found"
    fi
}

# Remove zinit
remove_zinit() {
    print_header "Removing Zinit Plugin Manager"
    
    local ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit"
    
    if [ -d "$ZINIT_HOME" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would remove: $ZINIT_HOME"
        else
            rm -rf "$ZINIT_HOME"
            print_success "Removed zinit directory"
        fi
    else
        print_info "Zinit not found"
    fi
    
    # Also remove zinit cache
    local ZINIT_CACHE="$HOME/.cache/zinit"
    if [ -d "$ZINIT_CACHE" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would remove: $ZINIT_CACHE"
        else
            rm -rf "$ZINIT_CACHE"
            print_success "Removed zinit cache"
        fi
    fi
}

# Remove installed tools (lazygit, lazydocker, yazi)
remove_tools() {
    print_header "Removing Installed Tools"
    
    # Remove lazygit
    if [ -f "/usr/local/bin/lazygit" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would remove: /usr/local/bin/lazygit"
        else
            sudo rm -f /usr/local/bin/lazygit
            print_success "Removed lazygit"
        fi
    fi
    
    # Remove lazydocker
    if [ -f "$HOME/.local/bin/lazydocker" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would remove: $HOME/.local/bin/lazydocker"
        else
            rm -f "$HOME/.local/bin/lazydocker"
            print_success "Removed lazydocker"
        fi
    elif [ -f "/usr/local/bin/lazydocker" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would remove: /usr/local/bin/lazydocker"
        else
            sudo rm -f /usr/local/bin/lazydocker
            print_success "Removed lazydocker"
        fi
    fi
    
    # Remove yazi
    if [ -f "/usr/local/bin/yazi" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would remove: /usr/local/bin/yazi"
            print_info "[DRY-RUN] Would remove: /usr/local/bin/ya"
        else
            sudo rm -f /usr/local/bin/yazi
            sudo rm -f /usr/local/bin/ya
            print_success "Removed yazi"
        fi
    fi
    
    # Remove starship (optional, installed via official installer)
    if [ -f "/usr/local/bin/starship" ]; then
        print_warning "Starship found at /usr/local/bin/starship"
        print_info "To remove starship, run: sudo rm /usr/local/bin/starship"
    fi
}

# Remove neovim plugins and cache
remove_nvim_data() {
    print_header "Removing Neovim Data"
    
    local nvim_dirs=(
        "$HOME/.local/share/nvim"
        "$HOME/.local/state/nvim"
        "$HOME/.cache/nvim"
    )
    
    for dir in "${nvim_dirs[@]}"; do
        if [ -d "$dir" ]; then
            if $DRY_RUN; then
                print_info "[DRY-RUN] Would remove: $dir"
            else
                rm -rf "$dir"
                print_success "Removed: $dir"
            fi
        fi
    done
}

# Restore default shell
restore_default_shell() {
    print_header "Restoring Default Shell"
    
    if [ "$SHELL" = "$(which zsh 2>/dev/null)" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would change shell back to bash"
        else
            if chsh -s "$(which bash)"; then
                print_success "Default shell changed to bash"
                print_warning "Please log out and log back in for changes to take effect"
            else
                print_error "Failed to change default shell"
                print_info "You can manually run: chsh -s $(which bash)"
            fi
        fi
    else
        print_info "Shell is not zsh, skipping"
    fi
}

# Restore MOTD
restore_motd() {
    print_header "Restoring Default MOTD"
    
    # Restore /etc/motd
    if [ -f /etc/motd.bak ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would restore /etc/motd from backup"
        else
            sudo mv /etc/motd.bak /etc/motd 2>/dev/null || true
            print_success "Restored /etc/motd"
        fi
    fi
    
    # Re-enable pam_motd
    if [ -f /etc/pam.d/sshd ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would re-enable pam_motd in /etc/pam.d/sshd"
        else
            sudo sed -i 's/^#\(session.*pam_motd\)/\1/' /etc/pam.d/sshd 2>/dev/null || true
        fi
    fi
    if [ -f /etc/pam.d/login ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would re-enable pam_motd in /etc/pam.d/login"
        else
            sudo sed -i 's/^#\(session.*pam_motd\)/\1/' /etc/pam.d/login 2>/dev/null || true
        fi
    fi
    
    # Re-enable update-motd scripts
    if [ -d /etc/update-motd.d ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would re-enable update-motd scripts"
        else
            sudo chmod +x /etc/update-motd.d/* 2>/dev/null || true
            print_success "Re-enabled update-motd scripts"
        fi
    fi
    
    # Restore motd.sh on RHEL/CentOS/Fedora
    if [ -f /etc/profile.d/motd.sh.bak ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would restore /etc/profile.d/motd.sh"
        else
            sudo mv /etc/profile.d/motd.sh.bak /etc/profile.d/motd.sh 2>/dev/null || true
            print_success "Restored /etc/profile.d/motd.sh"
        fi
    fi
}

# Find and restore from backup
restore_backup() {
    print_header "Restoring from Backup"
    
    # Find latest backup directory
    local BACKUP_DIR=""
    
    # Check state file first
    if [ -f "$STATE_FILE" ]; then
        source "$STATE_FILE"
        if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
            print_info "Found backup from state file: $BACKUP_DIR"
        else
            BACKUP_DIR=""
        fi
    fi
    
    # If not found, search for backup directories
    if [ -z "$BACKUP_DIR" ]; then
        BACKUP_DIR=$(ls -td "$HOME"/.dotfiles-backup-* 2>/dev/null | head -1)
    fi
    
    if [ -z "$BACKUP_DIR" ] || [ ! -d "$BACKUP_DIR" ]; then
        print_warning "No backup directory found"
        return 1
    fi
    
    print_info "Restoring from: $BACKUP_DIR"
    
    # Restore files
    if [ -f "$BACKUP_DIR/.zshrc" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would restore: .zshrc"
        else
            cp "$BACKUP_DIR/.zshrc" "$HOME/.zshrc"
            print_success "Restored: .zshrc"
        fi
    fi
    
    if [ -f "$BACKUP_DIR/.zshenv" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would restore: .zshenv"
        else
            cp "$BACKUP_DIR/.zshenv" "$HOME/.zshenv"
            print_success "Restored: .zshenv"
        fi
    fi
    
    if [ -f "$BACKUP_DIR/.bashrc" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would restore: .bashrc"
        else
            cp "$BACKUP_DIR/.bashrc" "$HOME/.bashrc"
            print_success "Restored: .bashrc"
        fi
    fi
    
    if [ -f "$BACKUP_DIR/.bash_aliases" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would restore: .bash_aliases"
        else
            cp "$BACKUP_DIR/.bash_aliases" "$HOME/.bash_aliases"
            print_success "Restored: .bash_aliases"
        fi
    fi
    
    if [ -f "$BACKUP_DIR/.tmux.conf" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would restore: .tmux.conf"
        else
            cp "$BACKUP_DIR/.tmux.conf" "$HOME/.tmux.conf"
            print_success "Restored: .tmux.conf"
        fi
    fi
    
    if [ -f "$BACKUP_DIR/.gitconfig" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would restore: .gitconfig"
        else
            cp "$BACKUP_DIR/.gitconfig" "$HOME/.gitconfig"
            print_success "Restored: .gitconfig"
        fi
    fi
    
    print_success "Backup restoration complete"
}

# Remove state file
remove_state() {
    if [ -f "$STATE_FILE" ]; then
        if $DRY_RUN; then
            print_info "[DRY-RUN] Would remove state file"
        else
            rm -f "$STATE_FILE"
            print_success "Removed state file"
        fi
    fi
}

# Main uninstall
main() {
    local REMOVE_ALL=false
    local REMOVE_CONFIGS=false
    local REMOVE_THEMES=false
    local REMOVE_TOOLS=false
    local DO_RESTORE=false
    local KEEP_SHELL=false
    DRY_RUN=false
    
    # Parse arguments
    if [ $# -eq 0 ]; then
        show_usage
        exit 0
    fi
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --all)
                REMOVE_ALL=true
                shift
                ;;
            --configs)
                REMOVE_CONFIGS=true
                shift
                ;;
            --themes)
                REMOVE_THEMES=true
                shift
                ;;
            --tools)
                REMOVE_TOOLS=true
                shift
                ;;
            --restore)
                DO_RESTORE=true
                shift
                ;;
            --keep-shell)
                KEEP_SHELL=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    print_header "VPS Dotfiles Uninstaller"
    
    if $DRY_RUN; then
        echo -e "${YELLOW}DRY-RUN MODE: No changes will be made${NC}\n"
    fi
    
    # Confirmation
    if ! $DRY_RUN; then
        echo -e "${RED}WARNING: This will remove dotfiles configurations!${NC}"
        echo ""
        read -p "Are you sure you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Uninstall cancelled"
            exit 0
        fi
    fi
    
    # Execute based on options
    if $REMOVE_ALL; then
        remove_symlinks
        remove_bat_themes
        remove_lazygit_themes
        remove_yazi_config
        remove_zinit
        remove_tools
        remove_nvim_data
        restore_motd
        if ! $KEEP_SHELL; then
            restore_default_shell
        fi
        remove_state
    else
        if $REMOVE_CONFIGS; then
            remove_symlinks
            remove_zinit
        fi
        
        if $REMOVE_THEMES; then
            remove_bat_themes
            remove_lazygit_themes
            remove_yazi_config
        fi
        
        if $REMOVE_TOOLS; then
            remove_tools
        fi
    fi
    
    # Restore backup if requested
    if $DO_RESTORE; then
        restore_backup
    fi
    
    print_header "Uninstall Complete!"
    
    if $DRY_RUN; then
        echo -e "${YELLOW}This was a dry run. No changes were made.${NC}"
        echo -e "${YELLOW}Run without --dry-run to actually remove files.${NC}"
    else
        echo -e "${GREEN}Dotfiles have been removed.${NC}\n"
        
        if $DO_RESTORE; then
            echo -e "${CYAN}Backup files have been restored.${NC}"
        fi
        
        echo ""
        echo -e "${YELLOW}Note:${NC}"
        echo -e "  - The dotfiles directory ($DOTFILES_DIR) was NOT removed"
        echo -e "  - To completely remove, run: rm -rf $DOTFILES_DIR"
        echo ""
        
        if ! $KEEP_SHELL; then
            echo -e "${YELLOW}Please log out and log back in for shell changes to take effect.${NC}"
        fi
    fi
}

# Run main
main "$@"
