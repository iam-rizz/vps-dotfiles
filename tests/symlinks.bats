#!/usr/bin/env bats
# Feature: vps-dotfiles, Property 4: Symlink Creation Completeness
# Validates: Requirements 5.2

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Expected symlinks
EXPECTED_SYMLINKS=(
    "$HOME/.zshrc"
    "$HOME/.zshenv"
    "$HOME/.bashrc"
    "$HOME/.bash_aliases"
    "$HOME/.tmux.conf"
    "$HOME/.gitconfig"
    "$HOME/.config/starship.toml"
)

@test "link.sh script exists and is executable" {
    [ -x "$DOTFILES_DIR/scripts/link.sh" ]
}

@test ".zshrc symlink exists and points to dotfiles" {
    [ -L "$HOME/.zshrc" ]
    readlink "$HOME/.zshrc" | grep -q "dotfiles"
}

@test ".zshenv symlink exists and points to dotfiles" {
    [ -L "$HOME/.zshenv" ]
    readlink "$HOME/.zshenv" | grep -q "dotfiles"
}

@test ".bashrc symlink exists and points to dotfiles" {
    [ -L "$HOME/.bashrc" ]
    readlink "$HOME/.bashrc" | grep -q "dotfiles"
}

@test ".tmux.conf symlink exists and points to dotfiles" {
    [ -L "$HOME/.tmux.conf" ]
    readlink "$HOME/.tmux.conf" | grep -q "dotfiles"
}

@test ".gitconfig symlink exists and points to dotfiles" {
    [ -L "$HOME/.gitconfig" ]
    readlink "$HOME/.gitconfig" | grep -q "dotfiles"
}

@test "starship.toml symlink exists and points to dotfiles" {
    [ -L "$HOME/.config/starship.toml" ]
    readlink "$HOME/.config/starship.toml" | grep -q "dotfiles"
}
