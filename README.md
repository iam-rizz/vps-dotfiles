# VPS Dotfiles

Dotfiles for VPS/Linux servers with Zsh, Zinit, Starship, and Catppuccin Mocha theme.

Inspired by [caelestia-dots](https://github.com/caelestia-dots) and [JaKooLit Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots).

## Features

- **Zsh** with [Zinit](https://github.com/zdharma-continuum/zinit) plugin manager (turbo mode for fast loading)
- **[Starship](https://starship.rs/)** cross-shell prompt with Catppuccin Mocha theme
  - Bold/Box mode with background colors
  - Minimal mode with text colors only
  - Nerd Font symbols support (requires Nerd Font installation)
- **[btop](https://github.com/aristocratos/btop)** system monitor with Catppuccin theme
- **[fastfetch](https://github.com/fastfetch-cli/fastfetch)** system info display
  - Full config for default `fastfetch` command
  - Compact config for `ffc` alias (login screen style)
- **Neovim** with lazy.nvim and essential plugins
- **tmux** with sensible keybindings
- **Catppuccin Mocha** color scheme across all tools
- Security-focused with history filtering and secure permissions

## Requirements

**Important**: This dotfiles setup uses Nerd Font symbols extensively. You must install a Nerd Font and configure your terminal to use it.

**Recommended Font**: [Fira Code Nerd Font](https://www.nerdfonts.com/font-downloads)

### Installing Nerd Font

**On Linux:**
```bash
# Download and install Fira Code Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "Fira Code Regular Nerd Font Complete.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
fc-cache -fv
```

**Then configure your terminal emulator to use "FiraCode Nerd Font" or "FiraCode NF".**

Without a Nerd Font, icons will appear as boxes or question marks.

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

### Post-Installation (Optional)

**Install Bat Catppuccin Theme:**
```bash
~/.dotfiles/scripts/install-bat-theme.sh
```

This will download and install Catppuccin themes for bat (latte, frappe, macchiato, mocha).

**Install Lazy Tools (lazygit & lazydocker):**
```bash
~/.dotfiles/scripts/install-lazy-tools.sh
```

This will install lazygit (Git TUI) and lazydocker (Docker TUI) with Catppuccin Mocha theme.

**Install Lazygit Themes:**
```bash
~/.dotfiles/scripts/install-lazygit-themes.sh
```

This will download all Catppuccin themes for lazygit (latte, frappe, macchiato, mocha). Default: Macchiato.

**Install Neovim Plugins:**
```bash
nvim --headless "+Lazy! sync" +qa
```

This will install all Neovim plugins including Catppuccin theme, treesitter, lualine, etc.

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
- **Nerd Font** (recommended: [Fira Code Nerd Font](https://www.nerdfonts.com/font-downloads))
  - Required for proper icon display in Starship prompt
  - Install and configure in your terminal emulator

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
- lazygit - Git TUI (Terminal UI)
- lazydocker - Docker TUI

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

### Bat Theme Switching
| Command | Description |
|---------|-------------|
| `bat_theme latte` | Switch to Catppuccin Latte (light) |
| `bat_theme frappe` | Switch to Catppuccin Frappe (dark warm) |
| `bat_theme macchiato` | Switch to Catppuccin Macchiato (dark cool) |
| `bat_theme mocha` | Switch to Catppuccin Mocha (dark, default) |

### Lazygit Theme Switching
| Command | Description |
|---------|-------------|
| `lazygit_theme latte` | Switch to Catppuccin Latte (light) |
| `lazygit_theme frappe` | Switch to Catppuccin Frappe (dark warm) |
| `lazygit_theme macchiato` | Switch to Catppuccin Macchiato (dark cool, default) |
| `lazygit_theme mocha` | Switch to Catppuccin Mocha (dark) |

### Git
| Alias | Command |
|-------|---------|
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gl` | `git log --oneline` |
| `gco` | `git checkout` |
| `lg` | `lazygit` (Git TUI) |

### Docker
| Alias | Command |
|-------|---------|
| `dps` | `docker ps` (formatted) |
| `dexec` | `docker exec -it` |
| `dlogs` | `docker logs -f` |
| `dprune` | `docker system prune -af` |
| `lzd` | `lazydocker` (Docker TUI) |

### System
| Alias | Command |
|-------|---------|
| `update` | `sudo apt update && upgrade` |
| `ports` | `ss -tuln` |
| `reload!` | `source ~/.zshrc` |
| `ffc` | `fastfetch --config config-full.jsonc` (compact) |

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
- `prompt_bold` / `prompt_minimal` - Switch between prompt modes
- `bat_theme` - Switch bat color theme (latte/frappe/macchiato/mocha)
- `lazygit_theme` - Switch lazygit color theme (latte/frappe/macchiato/mocha)

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
  - Default: `~/.dotfiles/config/fastfetch/config.jsonc` (full info)
  - Compact: `~/.dotfiles/config/fastfetch/config-full.jsonc` (for `ffc` alias)
- **Lazygit**: `~/.config/lazygit/config.yml`
- **Lazydocker**: `~/.config/lazydocker/config.yml`

## Credits

- [caelestia-dots](https://github.com/caelestia-dots) - Aesthetic inspiration
- [JaKooLit Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots) - Modular structure inspiration
- [Catppuccin](https://github.com/catppuccin/catppuccin) - Color scheme
- [Zinit](https://github.com/zdharma-continuum/zinit) - Plugin manager
- [Starship](https://starship.rs/) - Cross-shell prompt

## License

MIT License
