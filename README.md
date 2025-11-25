# Dotfiles

Personal macOS development environment configuration.

## Tech Stack

| Component | Tool | Description |
|-----------|------|-------------|
| **Shell** | [ZSH](https://www.zsh.org/) + [Zinit](https://github.com/zdharma-continuum/zinit) | Modern shell with plugin manager |
| **Prompt** | [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | Fast, customizable prompt |
| **Terminal** | [Kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated terminal |
| **Multiplexer** | [Tmux](https://github.com/tmux/tmux) | Terminal multiplexer |
| **Editor** | [Neovim](https://neovim.io/) + [lazy.nvim](https://github.com/folke/lazy.nvim) | Modern Vim with Lua config |
| **Version Manager** | [ASDF](https://asdf-vm.com/) | Multi-language version manager |
| **Package Manager** | [Homebrew](https://brew.sh/) | macOS package manager |

## Quick Start

```bash
# Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install Homebrew (if not installed)
make brew

# Install ASDF version manager
make asdf && source ~/.zshrc

# Install shell/editor configs
make profile

# Install dev tools (Python, Node.js, Go, etc.)
make tools

# (Optional) Install Kitty terminal
make kitty
```

## Documentation

| Document | Description |
|----------|-------------|
| [ZSH](doc/zsh.md) | Shell setup, plugins, aliases |
| [Tmux](doc/tmux.md) | Multiplexer keybindings, theme |
| [Kitty](doc/kitty.md) | Terminal settings, shortcuts |
| [Neovim](doc/nvim.md) | Editor plugins, LSP, keymaps |

## Repository Structure

```
~/.dotfiles/
├── README.md
├── CLAUDE.md              # AI assistant context
├── Makefile               # Main installer
├── doc/                   # Documentation
│   ├── zsh.md
│   ├── tmux.md
│   ├── kitty.md
│   └── nvim.md
├── config/
│   └── kitty/             # Kitty terminal
│       ├── kitty.conf
│       ├── conf.d/        # Modular configs
│       └── themes/        # Color themes
├── profile/
│   ├── Makefile
│   ├── zshrc              # ZSH main config
│   ├── zsh.d/             # Modular ZSH configs
│   ├── nvim/              # Neovim (Lua-based)
│   ├── tmux.conf          # Tmux base config
│   ├── tmux.local         # Tmux customizations
│   ├── gitconfig
│   ├── gitignore_global
│   └── editorconfig
├── tools/
│   └── Makefile           # ASDF tool installer
└── scripts/
    ├── dclean             # Docker cleanup
    ├── kleanup            # Kubernetes cleanup
    └── passwdgen          # Password generator
```

## Make Targets

### Main Makefile

```bash
make help       # Show all targets
make all        # Install everything
make brew       # Install Homebrew
make asdf       # Install ASDF
make profile    # Install shell/editor configs
make tools      # Install dev tools
make kitty      # Install Kitty terminal
```

### Tools Makefile (tools/)

```bash
make all        # Python, Node.js, Go, Terraform, K8s
make python     # Python (latest)
make nodejs     # Node.js (latest)
make golang     # Go (latest)
make terraform  # Terraform
make kubernetes # kubectl, helm, kind, kubectx
make aws        # AWS CLI
make gcloud     # Google Cloud SDK
make list       # List installed tools
make update     # Update ASDF plugins
```

## Features

### Shell (ZSH)
- Powerlevel10k instant prompt
- Syntax highlighting & autosuggestions
- Modern CLI aliases (bat, lsd, fd, ripgrep)
- Auto-tmux on login
- FZF fuzzy finder integration

### Editor (Neovim)
- lazy.nvim plugin manager
- LSP with Mason auto-install
- Treesitter syntax highlighting
- Telescope fuzzy finder
- Dracula theme

### Terminal (Kitty)
- GPU-accelerated rendering
- True color support
- Font ligatures
- Tmux-optimized

### Multiplexer (Tmux)
- Dracula theme
- Vim-aware navigation
- Mouse support
- Battery & time display

## Scripts

| Script | Description |
|--------|-------------|
| `dclean` | Remove stopped Docker containers, dangling images/volumes |
| `kleanup` | Remove old Kubernetes ReplicaSets, completed Jobs, evicted Pods |
| `passwdgen` | Generate random passwords (`passwdgen [length]`) |

## Requirements

- macOS Ventura 13.0+
- Apple Silicon (M1/M2/M3) or Intel
- Xcode Command Line Tools: `xcode-select --install`

## Customization

### Change Neovim Theme
Edit `profile/nvim/lua/plugins/editor.lua`

### Add ZSH Aliases
Edit `profile/zsh.d/alias.zsh`

### Modify Tmux Theme
Edit `profile/tmux.local`

### Change Kitty Theme
Edit `config/kitty/kitty.conf`:
```conf
include themes/dracula.conf
```

## Troubleshooting

```bash
# Reload ZSH
source ~/.zshrc

# Sync Neovim plugins
nvim +"Lazy sync" +qa

# Reload Tmux config
tmux source-file ~/.tmux.conf

# Reload Kitty config
Cmd+Shift+,
```

## License

Personal configuration. Use freely.
