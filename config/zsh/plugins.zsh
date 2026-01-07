# plugins.zsh - Zinit Plugin Configuration
# VPS Dotfiles - Fast loading with turbo mode

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Essential Plugins (loaded immediately)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Syntax highlighting - must be loaded before autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# Autosuggestions
zinit light zsh-users/zsh-autosuggestions

# Completions
zinit light zsh-users/zsh-completions

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Oh-My-Zsh Snippets (lazy loaded with turbo mode)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Core utilities
zinit wait lucid for \
    OMZP::git \
    OMZP::sudo \
    OMZP::command-not-found \
    OMZP::extract \
    OMZP::common-aliases

# SSH/GPG agents
zinit wait lucid for \
    OMZP::ssh-agent \
    OMZP::gpg-agent

# Package managers
zinit wait lucid for \
    OMZP::npm \
    OMZP::yarn \
    OMZP::nvm \
    OMZP::fnm

# Container tools
zinit wait lucid for \
    OMZP::docker \
    OMZP::docker-compose

# Language support
zinit wait lucid for \
    OMZP::node \
    OMZP::deno \
    OMZP::python \
    OMZP::ruby \
    OMZP::golang \
    OMZP::rust

# Development tools
zinit wait lucid for \
    OMZP::gh \
    OMZP::fzf

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Custom Plugins (lazy loaded)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Alias tips - reminds you of aliases
zinit wait lucid for \
    djui/alias-tips

# Auto-pair brackets and quotes
zinit wait lucid for \
    hlissner/zsh-autopair

# FZF tab completion
zinit wait lucid for \
    Aloxaf/fzf-tab

# "You should use" - reminds you of existing aliases
zinit wait lucid for \
    MichaelAquilina/zsh-you-should-use

# History search multi-word
zinit wait lucid for \
    zdharma-continuum/history-search-multi-word

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Plugin Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# FZF-tab configuration
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd -1 --color=always $realpath 2>/dev/null || ls -1 --color=always $realpath'

# SSH agent configuration
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent lazy yes
