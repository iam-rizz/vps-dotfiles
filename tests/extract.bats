#!/usr/bin/env bats
# Feature: vps-dotfiles, Property 2: Extract Function Format Coverage
# Validates: Requirements 3.5

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
FUNCTIONS_FILE="$DOTFILES_DIR/config/zsh/functions.zsh"

# Supported archive formats
ARCHIVE_FORMATS=(
    "tar.bz2"
    "tar.gz"
    "tar.xz"
    "bz2"
    "rar"
    "gz"
    "tar"
    "tbz2"
    "tgz"
    "zip"
    "Z"
    "7z"
    "xz"
)

@test "functions.zsh file exists" {
    [ -f "$FUNCTIONS_FILE" ]
}

@test "extract function is defined" {
    run grep -E "^extract\(\)" "$FUNCTIONS_FILE"
    [ "$status" -eq 0 ]
}

@test "extract handles tar.gz format" {
    run grep -E "tar\.gz.*tar xzf" "$FUNCTIONS_FILE"
    [ "$status" -eq 0 ]
}

@test "extract handles tar.bz2 format" {
    run grep -E "tar\.bz2.*tar xjf" "$FUNCTIONS_FILE"
    [ "$status" -eq 0 ]
}

@test "extract handles tar.xz format" {
    run grep -E "tar\.xz.*tar xJf" "$FUNCTIONS_FILE"
    [ "$status" -eq 0 ]
}

@test "extract handles zip format" {
    run grep -E "\.zip.*unzip" "$FUNCTIONS_FILE"
    [ "$status" -eq 0 ]
}

@test "extract handles 7z format" {
    run grep -E "\.7z.*7z x" "$FUNCTIONS_FILE"
    [ "$status" -eq 0 ]
}

@test "extract handles rar format" {
    run grep -E "\.rar.*unrar" "$FUNCTIONS_FILE"
    [ "$status" -eq 0 ]
}

@test "extract handles gz format" {
    run grep -E "\.gz.*gunzip" "$FUNCTIONS_FILE"
    [ "$status" -eq 0 ]
}

@test "extract handles bz2 format" {
    run grep -E "\.bz2.*bunzip2" "$FUNCTIONS_FILE"
    [ "$status" -eq 0 ]
}

@test "extract validates file existence" {
    run grep -E "if.*!.*-f" "$FUNCTIONS_FILE"
    [ "$status" -eq 0 ]
}
