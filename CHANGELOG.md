# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-11-25

### Added

#### Shell (ZSH)
- Modular ZSH configuration with `zsh.d/` directory structure
- [Zinit](https://github.com/zdharma-continuum/zinit) plugin manager with turbo-mode loading
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) instant prompt theme
- Modern CLI tool aliases: `bat`, `lsd`, `fd`, `ripgrep`
- Auto-tmux attachment on login (disabled in VS Code)
- FZF fuzzy finder integration
- Docker quick-start container aliases (kali, debian, ubuntu, alpine)
- macOS utility aliases (showfiles, flushdns, afk, ql)
- Network aliases (ip, localip, ports)

#### Editor (Neovim)
- Lua-based configuration with [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager
- LSP support with auto-install via [Mason](https://github.com/williamboman/mason.nvim)
- Pre-configured language servers: Lua, Python, TypeScript, Go, Rust, Bash, JSON, YAML, Docker, Terraform
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) syntax highlighting
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) fuzzy finder
- [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) file explorer
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) autocompletion with snippets
- [Gitsigns](https://github.com/lewis6991/gitsigns.nvim) git integration
- [Dracula](https://github.com/Mofiqul/dracula.nvim) color scheme
- [Lualine](https://github.com/nvim-lualine/lualine.nvim) statusline
- [Bufferline](https://github.com/akinsho/bufferline.nvim) buffer tabs
- [Which-key](https://github.com/folke/which-key.nvim) keybinding help

#### Terminal (Kitty)
- GPU-accelerated terminal configuration
- Modular config with `conf.d/` directory (fonts, keybindings, macos)
- Multiple theme options: Tokyo Night, Dracula, Nord, Material Dark
- JetBrains Mono Nerd Font configuration
- macOS-optimized keybindings

#### Multiplexer (Tmux)
- Based on [gpakosz/.tmux](https://github.com/gpakosz/.tmux) configuration
- Dracula-themed status bar with battery, time, and date
- Vim-aware pane navigation
- Mouse support
- Local customization via `tmux.local`

#### Tools & Scripts
- [ASDF](https://asdf-vm.com/) version manager integration
- Makefile-based installation system
- Tool installer for Python, Node.js, Go, Terraform, Kubernetes tools
- `dclean` - Docker cleanup script
- `kleanup` - Kubernetes cleanup script
- `passwdgen` - Password generator script

#### Configuration Files
- Git configuration with global gitignore
- EditorConfig for consistent coding styles

#### Documentation
- Comprehensive README with badges and installation guide
- Detailed documentation for ZSH, Neovim, Tmux, and Kitty
- MIT License

---

[1.0.0]: https://github.com/jcc-tck/.dotfiles/releases/tag/v1.0.0
