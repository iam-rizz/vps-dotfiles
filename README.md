# VPS Dotfiles

Dotfiles for VPS/Linux servers with Zsh, Zinit, Starship, and Catppuccin Mocha theme.

Inspired by [caelestia-dots](https://github.com/caelestia-dots) and [JaKooLit Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots).

## Features

- **Zsh** with [Zinit](https://github.com/zdharma-continuum/zinit) plugin manager (turbo mode for fast loading)
- **[Starship](https://starship.rs/)** cross-shell prompt with Catppuccin Mocha theme
  - Bold/Box mode with background colors
  - Minimal mode with text colors only
  - Nerd Font symbols support
- **[btop](https://github.com/aristocratos/btop)** system monitor with Catppuccin theme
- **[fastfetch](https://github.com/fastfetch-cli/fastfetch)** system info display
  - Compact config for login
  - Full config for `ff` alias
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

## Key Commands

### Dotfiles Management
| Command | Description |
|---------|-------------|
| `dotfiles_help` | Show all custom commands |
| `dotfiles_update` | Update dotfiles from GitHub |
| `dotfiles_status` | Show dotfiles status |
| `dotfiles_backup` | Backup current configs |
| `list_aliases` | List all custom aliases |
| `list_functions` | List all custom functions |

### Prompt Switching
| Command | Description |
|---------|-------------|
| `prompt_bold` | Switch to bold/box prompt |
| `prompt_minimal` | Switch to minimal prompt |

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
| `ff` | `fastfetch` (full config) |

## Custom Functions

- `mkcd` - Create directory and cd into it
- `tmpd` - Create temp directory and cd into it
- `extract` - Extract any archive
- `archive` - Create archive
- `qf` - Quick find file
- `qd` - Quick find directory
- `fif` - Search in files
- `sizeof` - Get size of directory
- `top10` - Show top 10 largest files
- `serve` - Quick HTTP server
- `genpass` - Generate random password
- `weather` - Show weather
- `cheat` - Cheat sheet lookup
- `gac` - Git add and commit
- `gacp` - Git add, commit and push
- `gclone` - Clone and cd into repo

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
- **Functions**: Edit `~/.dotfiles/config/zsh/functions.zsh`
- **Starship prompt**: 
  - Bold mode: `~/.dotfiles/config/starship/starship.toml`
  - Minimal mode: `~/.dotfiles/config/starship/starship-minimal.toml`
- **Plugins**: Edit `~/.dotfiles/config/zsh/plugins.zsh`
- **Fastfetch**:
  - Login: `~/.dotfiles/config/fastfetch/config.jsonc`
  - Full: `~/.dotfiles/config/fastfetch/config-full.jsonc`

## Credits

- [caelestia-dots](https://github.com/caelestia-dots) - Aesthetic inspiration
- [JaKooLit Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots) - Modular structure inspiration
- [Catppuccin](https://github.com/catppuccin/catppuccin) - Color scheme
- [Zinit](https://github.com/zdharma-continuum/zinit) - Plugin manager
- [Starship](https://starship.rs/) - Cross-shell prompt

## License

MIT License
