# ~/.bashrc - Bash Configuration
# VPS Dotfiles - Fallback for systems without zsh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# History Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help:* -h:history:clear"

# Append to history, don't overwrite
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Shell Options
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Check window size after each command
shopt -s checkwinsize

# Correct minor spelling errors in cd
shopt -s cdspell

# Enable extended globbing
shopt -s extglob

# Enable recursive globbing with **
shopt -s globstar 2>/dev/null

# Case-insensitive globbing
shopt -s nocaseglob

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Environment Variables
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="less"
export LESS="-R --use-color"
export LANG="${LANG:-en_US.UTF-8}"
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Path additions
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin:$PATH"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Load Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Prompt Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Use starship if available, otherwise use custom prompt
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
else
    # Catppuccin-inspired colors
    CYAN='\[\033[0;36m\]'
    MAGENTA='\[\033[0;35m\]'
    BLUE='\[\033[0;34m\]'
    GREEN='\[\033[0;32m\]'
    YELLOW='\[\033[0;33m\]'
    RED='\[\033[0;31m\]'
    RESET='\[\033[0m\]'

    # Git branch in prompt
    parse_git_branch() {
        git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }

    # Custom prompt
    PS1="${CYAN}\u${RESET}@${MAGENTA}\h${RESET}:${BLUE}\w${GREEN}\$(parse_git_branch)${RESET}\$ "
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Completion
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Enable programmable completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# FZF Integration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if command -v fzf &> /dev/null; then
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Startup
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Show system info on login
if command -v fastfetch &> /dev/null; then
    fastfetch
fi
