# ~/.bash_aliases - Bash Aliases
# VPS Dotfiles - Same aliases as zsh with tool detection

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# File System Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# lsd - Modern ls replacement
if command -v lsd &> /dev/null; then
    alias ls='lsd'
    alias ll='lsd -l'
    alias la='lsd -la'
    alias lt='lsd --tree'
    alias l='lsd -lah'
else
    alias ll='ls -l'
    alias la='ls -la'
    alias l='ls -lah'
fi

# bat - Modern cat replacement
if command -v batcat &> /dev/null; then
    alias cat='batcat'
    alias bat='batcat'
elif command -v bat &> /dev/null; then
    alias cat='bat'
fi

# fd - Modern find replacement
if command -v fdfind &> /dev/null; then
    alias fd='fdfind'
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Directory Navigation
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Git Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# System Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

alias e='${EDITOR:-nvim}'
alias v='${EDITOR:-nvim}'
alias reload!='source ~/.bashrc'
alias path='echo -e ${PATH//:/\\n}'
alias ports='ss -tuln'
alias myip='curl -s ifconfig.me'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Package manager (Debian/Ubuntu)
if command -v apt &> /dev/null; then
    alias update='sudo apt update && sudo apt upgrade -y'
    alias install='sudo apt install'
    alias remove='sudo apt remove'
    alias search='apt search'
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Docker Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if command -v docker &> /dev/null; then
    alias d='docker'
    alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
    alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
    alias dimg='docker images'
    alias dexec='docker exec -it'
    alias dlogs='docker logs -f'
    alias drm='docker rm -f'
    alias drmi='docker rmi'
    alias dprune='docker system prune -af'
fi

# Docker Compose
if command -v docker-compose &> /dev/null || command -v docker &> /dev/null; then
    alias dc='docker compose'
    alias dcu='docker compose up -d'
    alias dcd='docker compose down'
    alias dcl='docker compose logs -f'
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Safety Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Misc Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

alias c='clear'
alias h='history'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'

# Tmux
if command -v tmux &> /dev/null; then
    alias t='tmux'
    alias ta='tmux attach -t'
    alias tn='tmux new -s'
    alias tl='tmux list-sessions'
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
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
        *.bz2)       bunzip2 "$1"     ;;
        *.rar)       unrar x "$1"     ;;
        *.gz)        gunzip "$1"      ;;
        *.tar)       tar xf "$1"      ;;
        *.tbz2)      tar xjf "$1"     ;;
        *.tgz)       tar xzf "$1"     ;;
        *.zip)       unzip "$1"       ;;
        *.Z)         uncompress "$1"  ;;
        *.7z)        7z x "$1"        ;;
        *)           echo "Error: '$1' cannot be extracted" ;;
    esac
}
