# ~/.zshenv - Environment variables for Zsh
# This file is sourced on all invocations of the shell

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Dotfiles location
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Default editor
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"

# Pager
export PAGER="less"
export LESS="-R --use-color -Dd+r\$Du+b"

# Language
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# Path additions
typeset -U path  # Remove duplicates
path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.npm-global/bin"
    "/usr/local/bin"
    $path
)
export PATH

# Zinit home
export ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

# FZF defaults
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Bat theme (for syntax highlighting)
export BAT_THEME="Catppuccin-mocha"

# History file location
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

# GPG TTY
export GPG_TTY=$(tty)
