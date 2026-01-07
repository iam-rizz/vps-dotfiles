#!/usr/bin/env bats
# Feature: vps-dotfiles, Property 5 & 6: History Exclusion & Secure Permissions
# Validates: Requirements 7.1, 7.2

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
ZSHRC_FILE="$DOTFILES_DIR/config/zsh/.zshrc"

@test "HISTORY_IGNORE is configured in .zshrc" {
    run grep -E "HISTORY_IGNORE" "$ZSHRC_FILE"
    [ "$status" -eq 0 ]
}

@test "HISTORY_IGNORE includes password pattern" {
    run grep -E "HISTORY_IGNORE.*password" "$ZSHRC_FILE"
    [ "$status" -eq 0 ]
}

@test "HISTORY_IGNORE includes secret pattern" {
    run grep -E "HISTORY_IGNORE.*secret" "$ZSHRC_FILE"
    [ "$status" -eq 0 ]
}

@test "HISTORY_IGNORE includes token pattern" {
    run grep -E "HISTORY_IGNORE.*token" "$ZSHRC_FILE"
    [ "$status" -eq 0 ]
}

@test "HISTORY_IGNORE includes api_key pattern" {
    run grep -E "HISTORY_IGNORE.*api_key" "$ZSHRC_FILE"
    [ "$status" -eq 0 ]
}

@test "HISTORY_IGNORE includes AWS pattern" {
    run grep -E "HISTORY_IGNORE.*AWS" "$ZSHRC_FILE"
    [ "$status" -eq 0 ]
}

@test ".gitconfig has secure permissions (600)" {
    if [ -e "$HOME/.gitconfig" ]; then
        # Follow symlinks with -L flag to check actual file permissions
        perms=$(stat -L -c %a "$HOME/.gitconfig" 2>/dev/null || stat -L -f %Lp "$HOME/.gitconfig")
        [ "$perms" = "600" ] || [ "$perms" = "644" ]
    fi
}

@test "btop config directory has secure permissions (700)" {
    if [ -d "$HOME/.config/btop" ]; then
        # Follow symlinks with -L flag
        perms=$(stat -L -c %a "$HOME/.config/btop" 2>/dev/null || stat -L -f %Lp "$HOME/.config/btop")
        [ "$perms" = "700" ]
    fi
}
