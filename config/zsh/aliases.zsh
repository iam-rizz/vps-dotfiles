# aliases.zsh - Command Aliases
# VPS Dotfiles - With tool detection for graceful fallback

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# File System Aliases (with modern replacements)
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
alias ~='cd ~'
alias -- -='cd -'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Git Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gf='git fetch'
alias gl='git log --oneline'
alias glo='git log --oneline --graph --decorate'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gsw='git switch'
alias gswc='git switch -c'
alias gst='git stash'
alias gstp='git stash pop'
alias gm='git merge'
alias gr='git rebase'
alias gri='git rebase -i'
alias greset='git reset'
alias gclean='git clean -fd'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# System Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

alias e='${EDITOR:-nvim}'
alias v='${EDITOR:-nvim}'
alias reload!='source ~/.zshrc'
alias path='echo -e ${PATH//:/\\n}'
alias ports='ss -tuln'
alias myip='curl -s ifconfig.me'
alias localip='hostname -I | awk "{print \$1}"'

# Disk usage
alias df='df -h'
alias du='du -h'
alias dud='du -d 1 -h'
alias duf='du -sh *'

# Memory
alias free='free -h'

# Process
alias psg='ps aux | grep -v grep | grep -i'
alias top='htop 2>/dev/null || top'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Package Manager Aliases (Debian/Ubuntu)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if command -v apt &> /dev/null; then
    alias update='sudo apt update && sudo apt upgrade -y'
    alias install='sudo apt install'
    alias remove='sudo apt remove'
    alias search='apt search'
    alias autoremove='sudo apt autoremove -y'
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Docker Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if command -v docker &> /dev/null; then
    alias d='docker'
    alias dps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
    alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"'
    alias dimg='docker images'
    alias dexec='docker exec -it'
    alias dlogs='docker logs -f'
    alias drm='docker rm -f'
    alias drmi='docker rmi'
    alias dprune='docker system prune -af'
    alias dvol='docker volume ls'
    alias dnet='docker network ls'
    alias dstop='docker stop $(docker ps -q)'
    alias dstart='docker start'
    alias drestart='docker restart'
fi

# Docker Compose
if command -v docker-compose &> /dev/null || command -v docker &> /dev/null; then
    alias dc='docker compose'
    alias dcu='docker compose up -d'
    alias dcd='docker compose down'
    alias dcl='docker compose logs -f'
    alias dcr='docker compose restart'
    alias dcps='docker compose ps'
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Safety Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Misc Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

alias c='clear'
alias h='history'
alias j='jobs -l'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'
alias timestamp='date +%s'

# Fastfetch compact info
if command -v fastfetch &> /dev/null; then
    alias ffc='fastfetch --config ~/.dotfiles/config/fastfetch/config.jsonc'
fi

# Grep with color
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Make directory and cd into it
alias mkdir='mkdir -pv'

# Wget continue download
alias wget='wget -c'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Tmux Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if command -v tmux &> /dev/null; then
    alias t='tmux'
    alias ta='tmux attach -t'
    alias tn='tmux new -s'
    alias tl='tmux list-sessions'
    alias tk='tmux kill-session -t'
    alias tka='tmux kill-server'
fi
