# CLAUDE.md

Context for Claude Code when working with this repository.

## Overview

macOS dotfiles repository for ZSH, Tmux, Neovim, and Kitty terminal.

## Commands

```bash
# Installation
make brew                     # Install Homebrew
make asdf && source ~/.zshrc  # Install ASDF version manager
make profile                  # Install shell/editor configs
make tools                    # Install dev tools via ASDF
make kitty                    # Install Kitty terminal

# Tools (from tools/ directory)
make all            # Python, Node.js, Go, Terraform, K8s
make python         # Python only
make nodejs         # Node.js only
make list           # List installed tools
make update         # Update ASDF plugins

# Neovim
nvim                # First run installs plugins
:Lazy               # Plugin manager UI
:Mason              # LSP installer UI
:checkhealth        # Verify installation
```

## Structure

```
~/.dotfiles/
├── Makefile                   # Main installer
├── config/kitty/              # Kitty terminal
│   ├── kitty.conf             # Main config
│   ├── conf.d/                # Fonts, keybindings, macos
│   └── themes/                # Color themes
├── profile/
│   ├── Makefile               # Profile installer
│   ├── zshrc                  # ZSH main config → ~/.zshrc
│   ├── zsh.d/                 # Modular configs → ~/.zsh.d/
│   │   ├── env.zsh            # Environment variables
│   │   ├── options.zsh        # ZSH options
│   │   ├── history.zsh        # History settings
│   │   ├── plugins.zsh        # Zinit plugins
│   │   ├── completion.zsh     # Autocompletion
│   │   ├── colors.zsh         # Colors
│   │   ├── kitty.zsh          # Kitty integration
│   │   ├── alias.zsh          # Aliases
│   │   └── tools.zsh          # Tool configs
│   ├── nvim/                  # Neovim config → ~/.config/nvim
│   │   ├── init.lua           # Entry point
│   │   └── lua/
│   │       ├── config/        # Options, keymaps, autocmds
│   │       └── plugins/       # LSP, treesitter, editor, completion
│   ├── tmux.conf              # Tmux base → ~/.tmux.conf
│   ├── tmux.local             # Tmux local → ~/.tmux.conf.local
│   ├── gitconfig              # → ~/.gitconfig
│   ├── gitignore_global       # → ~/.gitignore_global
│   └── editorconfig           # → ~/.editorconfig
├── tools/
│   └── Makefile               # ASDF tool installer
├── scripts/
│   ├── dclean                 # Docker cleanup
│   ├── kleanup                # Kubernetes cleanup
│   └── passwdgen              # Password generator
└── doc/                       # Documentation
    ├── zsh.md
    ├── tmux.md
    ├── kitty.md
    └── nvim.md
```

## Key Patterns

- **Symlinks**: Makefiles create symlinks to home directory
- **Modular configs**: ZSH (zsh.d/) and Kitty (conf.d/) use includes
- **ASDF v0.18.0+**: Uses `asdf set --home` (Homebrew-installed)
- **Zinit**: ZSH plugin manager with Powerlevel10k theme
- **lazy.nvim**: Neovim plugin manager with LSP, Treesitter, Telescope
- **gpakosz/.tmux**: Base tmux with local overrides in tmux.local
- **Auto-tmux**: ZSH auto-attaches to tmux "main" session (disabled in VS Code)

## Requirements

- macOS Ventura 13.0+
- Apple Silicon or Intel Mac
- Homebrew for package management
