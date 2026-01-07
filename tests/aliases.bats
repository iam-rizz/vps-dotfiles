#!/usr/bin/env bats
# Feature: vps-dotfiles, Property 1: Alias Completeness
# Validates: Requirements 3.1, 3.2, 3.3

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
ALIASES_FILE="$DOTFILES_DIR/config/zsh/aliases.zsh"

# Expected aliases by category
GIT_ALIASES=("gs" "ga" "gaa" "gc" "gcm" "gp" "gpl" "gl" "gd" "gb" "gco" "gcb")
NAV_ALIASES=(".." "..." "...." ".....")
SYSTEM_ALIASES=("e" "v" "reload!" "ports" "myip" "df" "free")
DOCKER_ALIASES=("dps" "dpsa" "dimg" "dexec" "dlogs" "drm" "drmi" "dprune")

@test "aliases.zsh file exists" {
    [ -f "$ALIASES_FILE" ]
}

@test "git aliases are defined" {
    for alias in "${GIT_ALIASES[@]}"; do
        run grep -E "^alias $alias=" "$ALIASES_FILE"
        [ "$status" -eq 0 ]
    done
}

@test "navigation aliases are defined" {
    for alias in "${NAV_ALIASES[@]}"; do
        run grep -E "^alias $alias=" "$ALIASES_FILE"
        [ "$status" -eq 0 ]
    done
}

@test "system aliases are defined" {
    for alias in "${SYSTEM_ALIASES[@]}"; do
        run grep -E "^alias $alias=" "$ALIASES_FILE"
        [ "$status" -eq 0 ]
    done
}

@test "docker aliases are defined (conditional)" {
    for alias in "${DOCKER_ALIASES[@]}"; do
        run grep -E "alias $alias=" "$ALIASES_FILE"
        [ "$status" -eq 0 ]
    done
}

@test "safety aliases are defined" {
    run grep -E "^alias rm=" "$ALIASES_FILE"
    [ "$status" -eq 0 ]
    run grep -E "^alias cp=" "$ALIASES_FILE"
    [ "$status" -eq 0 ]
    run grep -E "^alias mv=" "$ALIASES_FILE"
    [ "$status" -eq 0 ]
}
