# VPS Dotfiles

Dotfiles for VPS/Linux servers with Zsh, Zinit, Starship, and Catppuccin Mocha theme.

Inspired by [caelestia-dots](https://github.com/caelestia-dots) and [JaKooLit Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots).

## Features

- **Zsh** with [Zinit](https://github.com/zdharma-continuum/zinit) plugin manager (turbo mode for fast loading)
- **[Starship](https://starship.rs/)** cross-shell prompt with Catppuccin Mocha theme
- **[btop](https://github.com/aristocratos/btop)** system monitor with Catppuccin theme
- **[fastfetch](https://github.com/fastfetch-cli/fastfetch)** system info display
- **Neovim** with lazy.nvim and essential plugins
- **tmux** with sensible keybindings
- **Catppuccin Mocha** color scheme across all tools
- Security-focused with history filtering and secure permissions

## Structure

```
~/.dotfiles/
├── config/
│   ├── zsh/           # Zsh configuration + zinit plugins
│   ├── bash/          # Bash fallback configuration
│   ├── starship/      # Starship prompt configuration
│   ├── tmux/          # Tmux configuration
│   ├── nvim/          # Neovim configuration
│   ├── btop/          # Btop system monitor config
│   ├── fastfetch/     # Fastfetch system info config
│   └── git/           # Git configuration
├── scripts/           # Installation & management scripts
├── themes/            # Catppuccin theme files
└── install.sh         # Main installation script
```

## Installation

### Quick Install

```bash
git clone https://github.com/iam-rizz/vps-dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --all
```

### Options

```bash
./install.sh [options]

Options:
  --all           Install all components (recommended)
  --shell         Install shell configs only
  --tools         Install tool configs only
  --no-backup     Skip backup of existing files
  --help          Show help message
```

## Dependencies

### Required
- zsh
- git
- curl

### Optional (Recommended)
- starship - Cross-shell prompt
- btop - System monitor
- fastfetch - System info display
- lsd - Modern ls replacement
- bat - Modern cat replacement
- fzf - Fuzzy finder
- ripgrep - Modern grep replacement
- tmux - Terminal multiplexer
- neovim - Text editor

## Key Aliases

### Git
| Alias | Command |
|-------|---------|
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gl` | `git log --oneline` |
| `gco` | `git checkout` |

### Docker
| Alias | Command |
|-------|---------|
| `dps` | `docker ps` (formatted) |
| `dexec` | `docker exec -it` |
| `dlogs` | `docker logs -f` |
| `dprune` | `docker system prune -af` |

### System
| Alias | Command |
|-------|---------|
| `update` | `sudo apt update && upgrade` |
| `ports` | `ss -tuln` |
| `reload!` | `source ~/.zshrc` |

## Zinit Plugins

Essential plugins loaded with turbo mode:
- zsh-syntax-highlighting
- zsh-autosuggestions
- zsh-completions
- fzf-tab
- alias-tips
- Oh-My-Zsh snippets (git, docker, sudo, extract, etc.)

## Updating

```bash
# Using the function
dotfiles_update

# Or manually
cd ~/.dotfiles && git pull && ./scripts/link.sh
```

## Customization

- **Aliases**: Edit `~/.dotfiles/config/zsh/aliases.zsh`
- **Starship prompt**: Edit `~/.dotfiles/config/starship/starship.toml`
- **Plugins**: Edit `~/.dotfiles/config/zsh/plugins.zsh`

## Credits

- [caelestia-dots](https://github.com/caelestia-dots) - Aesthetic inspiration
- [JaKooLit Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots) - Modular structure inspiration
- [Catppuccin](https://github.com/catppuccin/catppuccin) - Color scheme
- [Zinit](https://github.com/zdharma-continuum/zinit) - Plugin manager
- [Starship](https://starship.rs/) - Cross-shell prompt

## License

MIT License
