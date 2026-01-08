#!/usr/bin/env bash
#
# VPS Dotfiles Install Script
# Inspired by caelestia-dots and JaKooLit Hyprland-Dots
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
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
STATE_FILE="$DOTFILES_DIR/.state"

# Core dependencies (required)
CORE_DEPS=(
    "zsh"
    "git"
    "curl"
    "wget"
)

# Optional tools
OPTIONAL_DEPS=(
    "starship"
    "btop"
    "fastfetch"
    "lsd"
    "bat"
    "fzf"
    "ripgrep"
    "fd-find"
    "tmux"
    "neovim"
    "htop"
)

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

# Detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_LIKE=$ID_LIKE
    elif [ -f /etc/debian_version ]; then
        DISTRO="debian"
    elif [ -f /etc/redhat-release ]; then
        DISTRO="rhel"
    elif [ -f /etc/arch-release ]; then
        DISTRO="arch"
    else
        DISTRO="unknown"
    fi
    echo "$DISTRO"
}

# Get package manager
get_pkg_manager() {
    local distro=$(detect_distro)
    case "$distro" in
        ubuntu|debian|linuxmint|pop)
            echo "apt"
            ;;
        fedora|rhel|centos|rocky|almalinux)
            echo "dnf"
            ;;
        arch|manjaro|endeavouros)
            echo "pacman"
            ;;
        opensuse*)
            echo "zypper"
            ;;
        *)
            # Check for package managers directly
            if command -v apt &> /dev/null; then
                echo "apt"
            elif command -v dnf &> /dev/null; then
                echo "dnf"
            elif command -v pacman &> /dev/null; then
                echo "pacman"
            else
                echo "unknown"
            fi
            ;;
    esac
}


# Install package based on distro
install_pkg() {
    local pkg=$1
    local pkg_manager=$(get_pkg_manager)
    
    case "$pkg_manager" in
        apt)
            sudo apt install -y "$pkg" 2>/dev/null || return 1
            ;;
        dnf)
            sudo dnf install -y "$pkg" 2>/dev/null || return 1
            ;;
        pacman)
            sudo pacman -S --noconfirm "$pkg" 2>/dev/null || return 1
            ;;
        zypper)
            sudo zypper install -y "$pkg" 2>/dev/null || return 1
            ;;
        *)
            return 1
            ;;
    esac
}

# Check if command exists
cmd_exists() {
    command -v "$1" &> /dev/null
}

# Detect and disable old dotfiles
disable_old_dotfiles() {
    print_header "Detecting & Disabling Old Dotfiles"
    
    local OLD_DOTFILES_BACKUP="$HOME/.old-dotfiles-disabled-$(date +%Y%m%d-%H%M%S)"
    local found_old=0
    
    # Old dotfiles directories to check
    local old_dirs=(
        "$HOME/.oh-my-zsh"
        "$HOME/.zgen"
        "$HOME/.antigen"
        "$HOME/.zprezto"
        "$HOME/.zplug"
        "$HOME/.zinit"  # Old zinit location (we use ~/.local/share/zinit)
        "$HOME/dotfiles"
        "$HOME/dotfiles2"
        "$HOME/.dotfiles2"
        "$HOME/config"  # Old config folder in home
    )
    
    # Old config files to check
    local old_files=(
        "$HOME/.p10k.zsh"
        "$HOME/.zsh_welcome"
        "$HOME/.zshrc.pre-oh-my-zsh"
        "$HOME/.zshrc.omz-backup"
    )
    
    # Check for old dotfiles directories
    for dir in "${old_dirs[@]}"; do
        # Skip if it's our current dotfiles directory
        if [ "$dir" = "$DOTFILES_DIR" ]; then
            continue
        fi
        
        if [ -d "$dir" ]; then
            print_warning "Found old dotfiles: $dir"
            mkdir -p "$OLD_DOTFILES_BACKUP"
            mv "$dir" "$OLD_DOTFILES_BACKUP/$(basename "$dir")"
            print_success "Moved to: $OLD_DOTFILES_BACKUP/$(basename "$dir")"
            found_old=$((found_old + 1))
        fi
    done
    
    # Check for old config files
    for file in "${old_files[@]}"; do
        if [ -f "$file" ]; then
            print_warning "Found old config: $file"
            mkdir -p "$OLD_DOTFILES_BACKUP"
            mv "$file" "$OLD_DOTFILES_BACKUP/$(basename "$file")"
            print_success "Moved to: $OLD_DOTFILES_BACKUP/$(basename "$file")"
            found_old=$((found_old + 1))
        fi
    done
    
    # Check for symlinks pointing to old dotfiles
    local symlink_targets=(
        "$HOME/.zshrc"
        "$HOME/.zshenv"
        "$HOME/.bashrc"
        "$HOME/.bash_aliases"
        "$HOME/.tmux.conf"
        "$HOME/.gitconfig"
    )
    
    for link in "${symlink_targets[@]}"; do
        if [ -L "$link" ]; then
            local target
            target=$(readlink -f "$link" 2>/dev/null || true)
            # Check if symlink points to old dotfiles (not our current one)
            if [[ -n "$target" && "$target" != "$DOTFILES_DIR"* ]]; then
                if [[ "$target" == *"dotfiles"* || "$target" == *"config"* ]]; then
                    print_warning "Found old symlink: $link -> $target"
                    rm -f "$link"
                    print_success "Removed old symlink: $link"
                    found_old=$((found_old + 1))
                fi
            fi
        fi
    done
    
    # Clean up old zsh completion files
    local old_zcompdump=(
        "$HOME/.zcompdump"
        "$HOME/.zcompdump-"*
    )
    
    for file in "${old_zcompdump[@]}"; do
        if [ -f "$file" ] 2>/dev/null; then
            rm -f "$file" 2>/dev/null || true
        fi
    done
    print_info "Cleaned up old zsh completion cache"
    
    # Check for oh-my-zsh sourcing in existing .zshrc
    if [ -f "$HOME/.zshrc" ] && ! [ -L "$HOME/.zshrc" ]; then
        if grep -q "oh-my-zsh\|zgen\|antigen\|zprezto\|p10k\|powerlevel" "$HOME/.zshrc" 2>/dev/null; then
            print_warning "Found old framework references in .zshrc"
            mkdir -p "$OLD_DOTFILES_BACKUP"
            mv "$HOME/.zshrc" "$OLD_DOTFILES_BACKUP/.zshrc.old"
            print_success "Moved old .zshrc to backup"
            found_old=$((found_old + 1))
        fi
    fi
    
    # Summary
    if [ $found_old -gt 0 ]; then
        print_success "Disabled $found_old old dotfiles components"
        print_info "Old files backed up to: $OLD_DOTFILES_BACKUP"
        echo "$OLD_DOTFILES_BACKUP" > "$DOTFILES_DIR/.old-dotfiles-backup-location"
    else
        print_success "No old dotfiles detected"
    fi
}

# Install core dependencies
install_core_deps() {
    print_header "Installing Core Dependencies"
    
    local pkg_manager=$(get_pkg_manager)
    print_info "Detected package manager: $pkg_manager"
    
    # Update package lists
    case "$pkg_manager" in
        apt)
            print_info "Updating package lists..."
            sudo apt update -qq
            ;;
        dnf)
            print_info "Updating package lists..."
            sudo dnf check-update -q || true
            ;;
    esac
    
    for dep in "${CORE_DEPS[@]}"; do
        if cmd_exists "$dep"; then
            print_success "$dep is already installed"
        else
            print_info "Installing $dep..."
            if install_pkg "$dep"; then
                print_success "$dep installed successfully"
            else
                print_error "Failed to install $dep"
            fi
        fi
    done
}

# Install optional tools
install_optional_deps() {
    print_header "Installing Optional Tools"
    
    local pkg_manager=$(get_pkg_manager)
    
    # Package name mappings for different distros
    declare -A pkg_names_apt=(
        ["bat"]="bat"
        ["fd-find"]="fd-find"
        ["ripgrep"]="ripgrep"
        ["neovim"]="neovim"
        ["lsd"]="lsd"
    )
    
    declare -A pkg_names_dnf=(
        ["bat"]="bat"
        ["fd-find"]="fd-find"
        ["ripgrep"]="ripgrep"
        ["neovim"]="neovim"
        ["lsd"]="lsd"
    )
    
    declare -A pkg_names_pacman=(
        ["bat"]="bat"
        ["fd-find"]="fd"
        ["ripgrep"]="ripgrep"
        ["neovim"]="neovim"
        ["lsd"]="lsd"
    )
    
    for dep in "${OPTIONAL_DEPS[@]}"; do
        local pkg_name="$dep"
        
        # Get distro-specific package name
        case "$pkg_manager" in
            apt)
                [[ -n "${pkg_names_apt[$dep]}" ]] && pkg_name="${pkg_names_apt[$dep]}"
                ;;
            dnf)
                [[ -n "${pkg_names_dnf[$dep]}" ]] && pkg_name="${pkg_names_dnf[$dep]}"
                ;;
            pacman)
                [[ -n "${pkg_names_pacman[$dep]}" ]] && pkg_name="${pkg_names_pacman[$dep]}"
                ;;
        esac
        
        # Check if already installed (check both original name and mapped name)
        if cmd_exists "$dep" || cmd_exists "$pkg_name"; then
            print_success "$dep is already installed"
        else
            print_info "Installing $dep ($pkg_name)..."
            if install_pkg "$pkg_name"; then
                print_success "$dep installed successfully"
            else
                print_warning "Could not install $dep from package manager"
            fi
        fi
    done
    
    # Install starship if not present
    if ! cmd_exists starship; then
        print_info "Installing starship via official installer..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        print_success "Starship installed"
    fi
}

# Backup existing configs
backup_configs() {
    print_header "Backing Up Existing Configurations"
    
    local files_to_backup=(
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
    
    local backed_up=0
    
    for file in "${files_to_backup[@]}"; do
        if [ -f "$file" ] || [ -L "$file" ]; then
            mkdir -p "$BACKUP_DIR/$(dirname "${file#$HOME/}")"
            cp -P "$file" "$BACKUP_DIR/${file#$HOME/}" 2>/dev/null || true
            print_info "Backed up: $file"
            backed_up=$((backed_up + 1))
        fi
    done
    
    if [ $backed_up -gt 0 ]; then
        print_success "Backed up $backed_up files to $BACKUP_DIR"
    else
        print_info "No existing configs to backup"
    fi
}


# Create symlinks
create_symlinks() {
    print_header "Creating Symlinks"
    
    # Ensure config directories exist
    mkdir -p "$HOME/.config/btop/themes"
    mkdir -p "$HOME/.config/fastfetch"
    mkdir -p "$HOME/.config/nvim/lua"
    
    # Define symlinks: source -> destination
    declare -A symlinks=(
        ["$DOTFILES_DIR/config/zsh/.zshrc"]="$HOME/.zshrc"
        ["$DOTFILES_DIR/config/zsh/.zshenv"]="$HOME/.zshenv"
        ["$DOTFILES_DIR/config/bash/.bashrc"]="$HOME/.bashrc"
        ["$DOTFILES_DIR/config/bash/.bash_aliases"]="$HOME/.bash_aliases"
        ["$DOTFILES_DIR/config/starship/starship.toml"]="$HOME/.config/starship.toml"
        ["$DOTFILES_DIR/config/tmux/.tmux.conf"]="$HOME/.tmux.conf"
        ["$DOTFILES_DIR/config/btop/btop.conf"]="$HOME/.config/btop/btop.conf"
        ["$DOTFILES_DIR/config/fastfetch/config.jsonc"]="$HOME/.config/fastfetch/config.jsonc"
        ["$DOTFILES_DIR/config/nvim/init.lua"]="$HOME/.config/nvim/init.lua"
        ["$DOTFILES_DIR/config/git/.gitconfig"]="$HOME/.gitconfig"
        ["$DOTFILES_DIR/config/git/.gitignore"]="$HOME/.gitignore_global"
        ["$DOTFILES_DIR/themes/catppuccin/btop.theme"]="$HOME/.config/btop/themes/catppuccin_mocha.theme"
    )
    
    for src in "${!symlinks[@]}"; do
        local dest="${symlinks[$src]}"
        
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
    
    # Set secure permissions
    chmod 600 "$HOME/.gitconfig" 2>/dev/null || true
    chmod 700 "$HOME/.config/btop" 2>/dev/null || true
}

# Install zinit
install_zinit() {
    print_header "Installing Zinit Plugin Manager"
    
    local ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
    
    if [ -d "$ZINIT_HOME" ]; then
        print_success "Zinit is already installed"
    else
        print_info "Installing zinit..."
        mkdir -p "$(dirname $ZINIT_HOME)"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
        print_success "Zinit installed successfully"
    fi
}

# Set zsh as default shell
set_default_shell() {
    print_header "Setting Default Shell"
    
    if [ "$SHELL" = "$(which zsh)" ]; then
        print_success "Zsh is already the default shell"
    else
        print_info "Setting zsh as default shell..."
        if chsh -s "$(which zsh)"; then
            print_success "Default shell changed to zsh"
            print_warning "Please log out and log back in for changes to take effect"
        else
            print_error "Failed to change default shell"
            print_info "You can manually run: chsh -s $(which zsh)"
        fi
    fi
}

# Save installation state
save_state() {
    cat > "$STATE_FILE" << EOF
INSTALLED_COMPONENTS="zsh,tmux,nvim,git,zinit,starship,btop,fastfetch"
BACKUP_DIR="$BACKUP_DIR"
INSTALL_DATE="$(date +%Y-%m-%d)"
LAST_UPDATE="$(date +%Y-%m-%d)"
EOF
    print_success "Installation state saved"
}

# Install additional themes and tools
install_additional_tools() {
    print_header "Installing Additional Tools & Themes"
    
    # Install bat themes
    if cmd_exists bat || cmd_exists batcat; then
        print_info "Installing bat Catppuccin themes..."
        if bash "$DOTFILES_DIR/scripts/install-bat-theme.sh"; then
            print_success "Bat themes installed"
        else
            print_warning "Failed to install bat themes"
        fi
    else
        print_warning "Bat not installed, skipping theme installation"
    fi
    
    # Install lazy tools (lazygit & lazydocker)
    print_info "Installing lazygit and lazydocker..."
    if bash "$DOTFILES_DIR/scripts/install-lazy-tools.sh"; then
        print_success "Lazy tools installed"
        
        # Install lazygit themes
        print_info "Installing lazygit Catppuccin themes..."
        if bash "$DOTFILES_DIR/scripts/install-lazygit-themes.sh"; then
            print_success "Lazygit themes installed"
        else
            print_warning "Failed to install lazygit themes"
        fi
    else
        print_warning "Failed to install lazy tools"
    fi
    
    # Install yazi file manager
    print_info "Installing yazi file manager..."
    if bash "$DOTFILES_DIR/scripts/install-yazi.sh"; then
        print_success "Yazi installed"
        
        # Install yazi theme
        print_info "Installing yazi Catppuccin theme..."
        if bash "$DOTFILES_DIR/scripts/install-yazi-theme.sh"; then
            print_success "Yazi theme installed"
        else
            print_warning "Failed to install yazi theme"
        fi
    else
        print_warning "Failed to install yazi"
    fi
    
    # Install Neovim plugins
    if cmd_exists nvim; then
        print_info "Installing Neovim plugins..."
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
        print_success "Neovim plugins installed"
    else
        print_warning "Neovim not installed, skipping plugin installation"
    fi
}

# Disable default MOTD
disable_default_motd() {
    print_header "Disabling Default MOTD"
    
    # Backup and disable /etc/motd
    if [ -f /etc/motd ]; then
        sudo mv /etc/motd /etc/motd.bak 2>/dev/null || true
        print_info "Backed up /etc/motd"
    fi
    
    # Disable pam_motd on Debian/Ubuntu
    if [ -f /etc/pam.d/sshd ]; then
        sudo sed -i 's/^session.*pam_motd/#&/' /etc/pam.d/sshd 2>/dev/null || true
    fi
    if [ -f /etc/pam.d/login ]; then
        sudo sed -i 's/^session.*pam_motd/#&/' /etc/pam.d/login 2>/dev/null || true
    fi
    
    # Disable update-motd scripts (Debian/Ubuntu)
    if [ -d /etc/update-motd.d ]; then
        sudo chmod -x /etc/update-motd.d/* 2>/dev/null || true
        print_info "Disabled update-motd scripts"
    fi
    
    # Disable motd on RHEL/CentOS/Fedora
    if [ -f /etc/profile.d/motd.sh ]; then
        sudo mv /etc/profile.d/motd.sh /etc/profile.d/motd.sh.bak 2>/dev/null || true
    fi
    
    print_success "Default MOTD disabled"
}

# Show usage
show_usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --all           Install all components (default)"
    echo "  --shell         Install shell configs only"
    echo "  --tools         Install tool configs only"
    echo "  --no-backup     Skip backup of existing files"
    echo "  --keep-old      Keep old dotfiles (don't disable them)"
    echo "  --uninstall     Remove dotfiles and restore backups"
    echo "  --help          Show this help message"
}

# Main installation
main() {
    local do_backup=true
    local install_all=true
    local shell_only=false
    local tools_only=false
    local keep_old=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --all)
                install_all=true
                shift
                ;;
            --shell)
                shell_only=true
                install_all=false
                shift
                ;;
            --tools)
                tools_only=true
                install_all=false
                shift
                ;;
            --no-backup)
                do_backup=false
                shift
                ;;
            --keep-old)
                keep_old=true
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
    
    print_header "VPS Dotfiles Installer"
    echo -e "${CYAN}Inspired by caelestia-dots & JaKooLit Hyprland-Dots${NC}\n"
    
    print_info "Detected distro: $(detect_distro)"
    print_info "Package manager: $(get_pkg_manager)"
    
    # Detect and disable old dotfiles FIRST (unless --keep-old)
    if ! $keep_old; then
        disable_old_dotfiles
    else
        print_warning "Skipping old dotfiles detection (--keep-old)"
    fi
    
    # Backup existing configs
    if $do_backup; then
        backup_configs
    fi
    
    # Install dependencies
    if $install_all || $shell_only; then
        install_core_deps
    fi
    
    if $install_all; then
        install_optional_deps
    fi
    
    # Install zinit
    if $install_all || $shell_only; then
        install_zinit
    fi
    
    # Create symlinks
    create_symlinks
    
    # Set default shell
    if $install_all || $shell_only; then
        set_default_shell
    fi
    
    # Disable default MOTD
    if $install_all; then
        disable_default_motd
    fi
    
    # Install additional tools and themes
    if $install_all; then
        install_additional_tools
    fi
    
    # Save state
    save_state
    
    print_header "Installation Complete!"
    echo -e "${GREEN}Your dotfiles have been installed successfully!${NC}\n"
    echo -e "${CYAN}Installed components:${NC}"
    echo -e "  ✓ Zsh with Zinit plugin manager"
    echo -e "  ✓ Starship prompt (Catppuccin Mocha)"
    echo -e "  ✓ Bat with Catppuccin themes"
    echo -e "  ✓ Lazygit with Catppuccin themes (default: Macchiato)"
    echo -e "  ✓ Lazydocker with Catppuccin theme"
    echo -e "  ✓ Yazi file manager with Catppuccin theme (default: Macchiato)"
    echo -e "  ✓ Neovim with plugins"
    echo -e "  ✓ Tmux, btop, fastfetch configs"
    echo ""
    echo -e "${CYAN}Quick commands:${NC}"
    echo -e "  ${YELLOW}dotfiles_help${NC}      - Show all custom commands"
    echo -e "  ${YELLOW}lg${NC}                 - Launch lazygit"
    echo -e "  ${YELLOW}lzd${NC}                - Launch lazydocker"
    echo -e "  ${YELLOW}y${NC} or ${YELLOW}fm${NC}           - Launch yazi file manager"
    echo -e "  ${YELLOW}bat_theme${NC}          - Switch bat theme"
    echo -e "  ${YELLOW}lazygit_theme${NC}      - Switch lazygit theme"
    echo -e "  ${YELLOW}prompt_bold${NC}        - Switch to bold prompt"
    echo -e "  ${YELLOW}prompt_minimal${NC}     - Switch to minimal prompt"
    echo ""
    echo -e "To apply changes, either:"
    echo -e "  ${CYAN}1.${NC} Log out and log back in"
    echo -e "  ${CYAN}2.${NC} Run: ${YELLOW}source ~/.zshrc${NC}"
    echo ""
    echo -e "Backup location: ${BLUE}$BACKUP_DIR${NC}"
}

# Run main
main "$@"
