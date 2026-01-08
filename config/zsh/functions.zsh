# functions.zsh - Custom Shell Functions
# VPS Dotfiles

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Directory Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Create a temporary directory and cd into it
tmpd() {
    local dir
    if [ $# -eq 0 ]; then
        dir=$(mktemp -d)
    else
        dir=$(mktemp -d -t "${1}.XXXXXX")
    fi
    cd "$dir"
    echo "Created temp directory: $dir"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Archive Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Extract any archive (fallback if OMZP::extract not available)
extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <file>"
        return 1
    fi
    
    if [ ! -f "$1" ]; then
        echo "Error: '$1' is not a valid file"
        return 1
    fi
    
    case "$1" in
        *.tar.bz2)   tar xjf "$1"     ;;
        *.tar.gz)    tar xzf "$1"     ;;
        *.tar.xz)    tar xJf "$1"     ;;
        *.tar.zst)   tar --zstd -xf "$1" ;;
        *.bz2)       bunzip2 "$1"     ;;
        *.rar)       unrar x "$1"     ;;
        *.gz)        gunzip "$1"      ;;
        *.tar)       tar xf "$1"      ;;
        *.tbz2)      tar xjf "$1"     ;;
        *.tgz)       tar xzf "$1"     ;;
        *.zip)       unzip "$1"       ;;
        *.Z)         uncompress "$1"  ;;
        *.7z)        7z x "$1"        ;;
        *.xz)        unxz "$1"        ;;
        *.lzma)      unlzma "$1"      ;;
        *)           echo "Error: '$1' cannot be extracted via extract()" ;;
    esac
}

# Create archive
archive() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: archive <archive_name> <files...>"
        return 1
    fi
    
    local archive_name="$1"
    shift
    
    case "$archive_name" in
        *.tar.gz|*.tgz)   tar czf "$archive_name" "$@" ;;
        *.tar.bz2|*.tbz2) tar cjf "$archive_name" "$@" ;;
        *.tar.xz)         tar cJf "$archive_name" "$@" ;;
        *.tar)            tar cf "$archive_name" "$@"  ;;
        *.zip)            zip -r "$archive_name" "$@"  ;;
        *.7z)             7z a "$archive_name" "$@"    ;;
        *)                echo "Error: Unknown archive format" ;;
    esac
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Dotfiles Management Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Update dotfiles
dotfiles_update() {
    local dotfiles_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"
    
    if [ ! -d "$dotfiles_dir" ]; then
        echo "Error: Dotfiles directory not found at $dotfiles_dir"
        return 1
    fi
    
    echo "Updating dotfiles..."
    cd "$dotfiles_dir"
    git pull
    
    # Re-source zshrc
    source "$HOME/.zshrc"
    echo "Dotfiles updated and reloaded!"
}

# Show dotfiles status
dotfiles_status() {
    local dotfiles_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"
    local state_file="$dotfiles_dir/.state"
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  VPS Dotfiles Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ -f "$state_file" ]; then
        source "$state_file"
        echo "Installed: $INSTALLED_COMPONENTS"
        echo "Install Date: $INSTALL_DATE"
        echo "Last Update: $LAST_UPDATE"
        echo "Backup Dir: $BACKUP_DIR"
    else
        echo "State file not found"
    fi
    
    echo ""
    echo "Git Status:"
    cd "$dotfiles_dir" && git status -s
}

# Backup current configs
dotfiles_backup() {
    local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    
    echo "Creating backup at $backup_dir..."
    mkdir -p "$backup_dir"
    
    local files=(
        "$HOME/.zshrc"
        "$HOME/.zshenv"
        "$HOME/.bashrc"
        "$HOME/.tmux.conf"
        "$HOME/.gitconfig"
        "$HOME/.config/starship.toml"
        "$HOME/.config/btop/btop.conf"
        "$HOME/.config/fastfetch/config.jsonc"
        "$HOME/.config/nvim/init.lua"
    )
    
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            cp "$file" "$backup_dir/"
            echo "Backed up: $file"
        fi
    done
    
    echo "Backup complete: $backup_dir"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Utility Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Quick find file
qf() {
    find . -type f -name "*$1*"
}

# Quick find directory
qd() {
    find . -type d -name "*$1*"
}

# Search in files
fif() {
    if [ $# -eq 0 ]; then
        echo "Usage: fif <search_term>"
        return 1
    fi
    grep -rn "$1" .
}

# Get size of directory
sizeof() {
    du -sh "${1:-.}"
}

# Show top 10 largest files/directories
top10() {
    du -ah "${1:-.}" | sort -rh | head -n 10
}

# Quick server (Python)
serve() {
    local port="${1:-8000}"
    echo "Starting server at http://localhost:$port"
    python3 -m http.server "$port"
}

# Generate random password
genpass() {
    local length="${1:-32}"
    openssl rand -base64 48 | tr -dc 'a-zA-Z0-9!@#$%^&*' | head -c "$length"
    echo
}

# Show weather
weather() {
    local city="${1:-}"
    curl -s "wttr.in/${city}?format=3"
}

# Cheat sheet
cheat() {
    curl -s "cheat.sh/$1"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Git Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Git add and commit
gac() {
    git add -A && git commit -m "$*"
}

# Git add, commit and push
gacp() {
    git add -A && git commit -m "$*" && git push
}

# Clone and cd into repo
gclone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Docker Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Docker shell into container
dsh() {
    docker exec -it "$1" /bin/sh
}

# Docker bash into container
dbash() {
    docker exec -it "$1" /bin/bash
}

# Docker remove all stopped containers
drmall() {
    docker rm $(docker ps -aq)
}

# Docker remove all images
drmiall() {
    docker rmi $(docker images -q)
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Theme Switching Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Switch bat theme
bat_theme() {
    if [ -z "$1" ]; then
        echo "Usage: bat_theme <latte|frappe|macchiato|mocha>"
        echo ""
        echo "Current theme: $BAT_THEME"
        echo ""
        echo "Available themes:"
        echo "  latte      - Light theme"
        echo "  frappe     - Dark theme (warm)"
        echo "  macchiato  - Dark theme (cool)"
        echo "  mocha      - Dark theme (default)"
        return 1
    fi
    
    local theme_name
    case "$1" in
        latte)
            theme_name="Catppuccin Latte"
            ;;
        frappe)
            theme_name="Catppuccin Frappe"
            ;;
        macchiato)
            theme_name="Catppuccin Macchiato"
            ;;
        mocha)
            theme_name="Catppuccin Mocha"
            ;;
        *)
            echo "Error: Unknown theme '$1'"
            echo "Available: latte, frappe, macchiato, mocha"
            return 1
            ;;
    esac
    
    export BAT_THEME="$theme_name"
    echo "Switched to: $theme_name"
    
    # Update .zshrc to persist
    local dotfiles_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"
    if [ -f "$dotfiles_dir/config/zsh/.zshrc" ]; then
        sed -i "s/export BAT_THEME=.*/export BAT_THEME=\"$theme_name\"/" "$dotfiles_dir/config/zsh/.zshrc"
        echo "Updated .zshrc with new theme"
    fi
}

# Switch lazygit theme
lazygit_theme() {
    if [ -z "$1" ]; then
        echo "Usage: lazygit_theme <latte|frappe|macchiato|mocha>"
        echo ""
        
        # Show current theme
        local config_file="$HOME/.config/lazygit/config.yml"
        if [ -f "$config_file" ]; then
            local current=$(grep "catppuccin-" "$config_file" | grep -oP 'catppuccin-\K[^.]+' | head -1)
            if [ -n "$current" ]; then
                echo "Current theme: $current"
            fi
        fi
        
        echo ""
        echo "Available themes:"
        echo "  latte      - Light theme"
        echo "  frappe     - Dark theme (warm)"
        echo "  macchiato  - Dark theme (cool, default)"
        echo "  mocha      - Dark theme"
        return 1
    fi
    
    local theme_file
    case "$1" in
        latte)
            theme_file="catppuccin-latte.yml"
            ;;
        frappe)
            theme_file="catppuccin-frappe.yml"
            ;;
        macchiato)
            theme_file="catppuccin-macchiato.yml"
            ;;
        mocha)
            theme_file="catppuccin-mocha.yml"
            ;;
        *)
            echo "Error: Unknown theme '$1'"
            echo "Available: latte, frappe, macchiato, mocha"
            return 1
            ;;
    esac
    
    # Check if theme file exists
    if [ ! -f "$HOME/.config/lazygit/themes/$theme_file" ]; then
        echo "Error: Theme file not found: $theme_file"
        echo "Run: ~/.dotfiles/scripts/install-lazygit-themes.sh"
        return 1
    fi
    
    # Update config.yml
    local config_file="$HOME/.config/lazygit/config.yml"
    if [ -f "$config_file" ]; then
        sed -i "s|catppuccin-[^.]*\.yml|$theme_file|" "$config_file"
        echo "Switched to: $1"
        echo "Restart lazygit to see changes"
    else
        echo "Error: config.yml not found"
        echo "Run: ~/.dotfiles/scripts/install-lazygit-themes.sh"
        return 1
    fi
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Prompt Switching Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Switch to bold/box prompt
prompt_bold() {
    local dotfiles_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"
    export STARSHIP_CONFIG="$dotfiles_dir/config/starship/starship.toml"
    echo "Switched to bold prompt"
}

# Switch to minimal prompt
prompt_minimal() {
    local dotfiles_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"
    export STARSHIP_CONFIG="$dotfiles_dir/config/starship/starship-minimal.toml"
    echo "Switched to minimal prompt"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Help Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# List all custom aliases
list_aliases() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Custom Aliases"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    local dotfiles_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"
    
    if [ -f "$dotfiles_dir/config/zsh/aliases.zsh" ]; then
        echo "📝 From aliases.zsh:"
        grep "^alias " "$dotfiles_dir/config/zsh/aliases.zsh" | sed 's/alias /  /' | sort
    fi
    
    echo ""
}

# List all custom functions
list_functions() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Custom Functions"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    local dotfiles_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"
    
    if [ -f "$dotfiles_dir/config/zsh/functions.zsh" ]; then
        echo "🔧 Available functions:"
        grep "^[a-zA-Z_][a-zA-Z0-9_]*() {" "$dotfiles_dir/config/zsh/functions.zsh" | \
            sed 's/() {//' | \
            awk '{print "  " $1}' | \
            sort
    fi
    
    echo ""
}

# Show all custom commands (aliases + functions)
dotfiles_help() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  VPS Dotfiles - Custom Commands"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    list_aliases
    list_functions
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Quick Commands:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  dotfiles_help      - Show this help"
    echo "  list_aliases       - List all aliases"
    echo "  list_functions     - List all functions"
    echo "  dotfiles_update    - Update dotfiles from GitHub"
    echo "  dotfiles_status    - Show dotfiles status"
    echo "  prompt_bold        - Switch to bold prompt"
    echo "  prompt_minimal     - Switch to minimal prompt"
    echo "  bat_theme          - Switch bat color theme"
    echo "  lazygit_theme      - Switch lazygit color theme"
    echo ""
}
