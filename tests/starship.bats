#!/usr/bin/env bats
# Feature: vps-dotfiles, Property 8: Starship Module Configuration
# Validates: Requirements 2.1, 2.2, 2.3, 2.4, 2.5

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
STARSHIP_FILE="$DOTFILES_DIR/config/starship/starship.toml"

# Required modules
REQUIRED_MODULES=("directory" "git_branch" "git_status" "cmd_duration" "hostname" "python" "nodejs")

@test "starship.toml file exists" {
    [ -f "$STARSHIP_FILE" ]
}

@test "starship.toml is valid TOML" {
    # Basic syntax check - look for common TOML patterns
    run grep -E "^\[" "$STARSHIP_FILE"
    [ "$status" -eq 0 ]
}

@test "directory module is configured" {
    run grep -E "^\[directory\]" "$STARSHIP_FILE"
    [ "$status" -eq 0 ]
}

@test "git_branch module is configured" {
    run grep -E "^\[git_branch\]" "$STARSHIP_FILE"
    [ "$status" -eq 0 ]
}

@test "git_status module is configured" {
    run grep -E "^\[git_status\]" "$STARSHIP_FILE"
    [ "$status" -eq 0 ]
}

@test "cmd_duration module is configured" {
    run grep -E "^\[cmd_duration\]" "$STARSHIP_FILE"
    [ "$status" -eq 0 ]
}

@test "hostname module is configured" {
    run grep -E "^\[hostname\]" "$STARSHIP_FILE"
    [ "$status" -eq 0 ]
}

@test "python module is configured" {
    run grep -E "^\[python\]" "$STARSHIP_FILE"
    [ "$status" -eq 0 ]
}

@test "nodejs module is configured" {
    run grep -E "^\[nodejs\]" "$STARSHIP_FILE"
    [ "$status" -eq 0 ]
}

@test "catppuccin palette is defined" {
    run grep -E "palette.*=.*catppuccin" "$STARSHIP_FILE"
    [ "$status" -eq 0 ]
}

@test "cmd_duration min_time is 2000ms" {
    run grep -E "min_time.*=.*2000" "$STARSHIP_FILE"
    [ "$status" -eq 0 ]
}
