#!/usr/bin/env bats
# Feature: vps-dotfiles, Property 7: Zinit Plugin Loading
# Validates: Requirements 1.2

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
PLUGINS_FILE="$DOTFILES_DIR/config/zsh/plugins.zsh"

# Expected plugins
ESSENTIAL_PLUGINS=(
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
    "zsh-completions"
)

OMZ_PLUGINS=(
    "git"
    "sudo"
    "extract"
    "docker"
    "docker-compose"
)

CUSTOM_PLUGINS=(
    "alias-tips"
    "zsh-autopair"
    "fzf-tab"
)

@test "plugins.zsh file exists" {
    [ -f "$PLUGINS_FILE" ]
}

@test "zsh-syntax-highlighting plugin is configured" {
    run grep -E "zsh-syntax-highlighting" "$PLUGINS_FILE"
    [ "$status" -eq 0 ]
}

@test "zsh-autosuggestions plugin is configured" {
    run grep -E "zsh-autosuggestions" "$PLUGINS_FILE"
    [ "$status" -eq 0 ]
}

@test "zsh-completions plugin is configured" {
    run grep -E "zsh-completions" "$PLUGINS_FILE"
    [ "$status" -eq 0 ]
}

@test "OMZP::git plugin is configured" {
    run grep -E "OMZP::git" "$PLUGINS_FILE"
    [ "$status" -eq 0 ]
}

@test "OMZP::sudo plugin is configured" {
    run grep -E "OMZP::sudo" "$PLUGINS_FILE"
    [ "$status" -eq 0 ]
}

@test "OMZP::extract plugin is configured" {
    run grep -E "OMZP::extract" "$PLUGINS_FILE"
    [ "$status" -eq 0 ]
}

@test "OMZP::docker plugin is configured" {
    run grep -E "OMZP::docker" "$PLUGINS_FILE"
    [ "$status" -eq 0 ]
}

@test "fzf-tab plugin is configured" {
    run grep -E "fzf-tab" "$PLUGINS_FILE"
    [ "$status" -eq 0 ]
}

@test "alias-tips plugin is configured" {
    run grep -E "alias-tips" "$PLUGINS_FILE"
    [ "$status" -eq 0 ]
}

@test "turbo mode is used for lazy loading" {
    run grep -E "zinit wait lucid" "$PLUGINS_FILE"
    [ "$status" -eq 0 ]
}
