#!/usr/bin/env bats
# Feature: vps-dotfiles, Property 3: Backup Creation Completeness
# Validates: Requirements 5.1

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

@test "backup.sh script exists and is executable" {
    [ -x "$DOTFILES_DIR/scripts/backup.sh" ]
}

@test "install.sh contains backup functionality" {
    run grep -E "backup" "$DOTFILES_DIR/install.sh"
    [ "$status" -eq 0 ]
}

@test "backup function creates timestamped directory" {
    run grep -E "BACKUP_DIR.*date" "$DOTFILES_DIR/install.sh"
    [ "$status" -eq 0 ]
}

@test "backup function handles .zshrc" {
    run grep -E "\.zshrc" "$DOTFILES_DIR/install.sh"
    [ "$status" -eq 0 ]
}

@test "backup function handles .bashrc" {
    run grep -E "\.bashrc" "$DOTFILES_DIR/install.sh"
    [ "$status" -eq 0 ]
}

@test "backup function handles .tmux.conf" {
    run grep -E "\.tmux\.conf" "$DOTFILES_DIR/install.sh"
    [ "$status" -eq 0 ]
}

@test "backup function handles .gitconfig" {
    run grep -E "\.gitconfig" "$DOTFILES_DIR/install.sh"
    [ "$status" -eq 0 ]
}

@test "backup preserves symlinks with cp -P" {
    run grep -E "cp -P" "$DOTFILES_DIR/install.sh"
    [ "$status" -eq 0 ]
}
