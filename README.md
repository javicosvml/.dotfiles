```
                                                       ..:::::::::..                 
                                                  ..:::aad8888888baa:::..            
                                               .::::d:?88888888888?::8b::::.         
                                             .:::d8888:?88888888??a888888b:::.       
                                           .:::d8888888a8888888aa8888888888b:::.     
                                          ::::dP::::::::88888888888::::::::Yb::::    
                                         ::::dP:::::::::Y888888888P:::::::::Yb::::   
                                        ::::d8:::::::::::Y8888888P:::::::::::8b::::  
                                       .::::88::::::::::::Y88888P::::::::::::88::::. 
                                       :::::Y8baaaaaaaaaa88P:T:Y88aaaaaaaaaad8P::::: 
                                       :::::::Y88888888888P::|::Y88888888888P::::::: 
                                       ::::::::::::::::888:::|:::888:::::::::::::::: 
                                       `:::::::::::::::8888888888888b::::::::::::::' 
                                        :::::::::::::::88888888888888::::::::::::::  
                                         :::::::::::::d88888888888888:::::::::::::   
                                          ::::::::::::88::88::88:::88::::::::::::    
                                           `::::::::::88::88::88:::88::::::::::'     
                                             `::::::::88::88::P::::88::::::::'       
                                               `::::::88::88:::::::88::::::'         
                                                  ``:::::::::::::::::::''            
                                                       ``:::::::::'' 
```
<div align="center">

# ~/.dotfiles

**My personal macOS development environment**

*Meticulously crafted configuration for a productive and beautiful terminal experience*

[![macOS](https://img.shields.io/badge/macOS-Ventura%2B-black?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/Shell-ZSH-green?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.zsh.org/)
[![Neovim](https://img.shields.io/badge/Editor-Neovim-57A143?style=flat-square&logo=neovim&logoColor=white)](https://neovim.io/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)](LICENSE)

<br>

[Features](#-features) •
[Installation](#-installation) •
[What's Included](#-whats-included) •
[Documentation](#-documentation) •
[Customization](#-customization)

<br>

<!-- Add your terminal screenshot here -->
<!-- ![Terminal Preview](assets/preview.png) -->

</div>

---

## Features

<table>
<tr>
<td width="50%">

### Terminal & Shell
- **ZSH** with [Zinit](https://github.com/zdharma-continuum/zinit) plugin manager
- **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** instant prompt
- **[Kitty](https://sw.kovidgoyal.net/kitty/)** GPU-accelerated terminal
- **[Tmux](https://github.com/tmux/tmux)** with [gpakosz/.tmux](https://github.com/gpakosz/.tmux) base

</td>
<td width="50%">

### Editor & Development
- **[Neovim](https://neovim.io/)** with Lua configuration
- **[lazy.nvim](https://github.com/folke/lazy.nvim)** plugin manager
- **LSP** with auto-install via [Mason](https://github.com/williamboman/mason.nvim)
- **[ASDF](https://asdf-vm.com/)** multi-language version manager

</td>
</tr>
</table>

### Highlights

| Feature | Description |
|---------|-------------|
| **Modular Design** | Organized configs with `zsh.d/` and `conf.d/` includes |
| **One-Command Install** | Get up and running with a single `make` command |
| **Modern CLI Tools** | `bat`, `lsd`, `fd`, `ripgrep`, `fzf` aliases built-in |
| **Auto-Tmux** | Automatically attaches to tmux session on login |
| **Dracula Theme** | Consistent theming across all tools |

---

## Installation

> [!IMPORTANT]
> Review the code before running. These are **my** personal dotfiles. Fork and customize!

### Prerequisites

- macOS Ventura 13.0+
- Apple Silicon (M1/M2/M3/M4) or Intel Mac
- Xcode Command Line Tools

```bash
xcode-select --install
```

### Quick Start

```bash
# Clone the repository
git clone https://github.com/jcc-tck/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install everything
make all
```

### Step-by-Step Installation

```bash
# 1. Install Homebrew
make brew

# 2. Install ASDF version manager
make asdf && source ~/.zshrc

# 3. Install shell/editor configurations
make profile

# 4. Install development tools (Python, Node.js, Go, etc.)
make tools

# 5. (Optional) Install Kitty terminal
make kitty
```

---

## What's Included

### Tech Stack

| Component | Tool | Description |
|:---------:|:----:|:------------|
| <img src="https://www.vectorlogo.zone/logos/gnu_bash/gnu_bash-icon.svg" width="20"> | **[ZSH](https://www.zsh.org/)** | Shell with [Zinit](https://github.com/zdharma-continuum/zinit) plugins |
| <img src="https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/prompt-styles-high-contrast.png" width="20"> | **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** | Lightning-fast prompt |
| <img src="https://sw.kovidgoyal.net/kitty/_static/kitty.svg" width="20"> | **[Kitty](https://sw.kovidgoyal.net/kitty/)** | GPU-accelerated terminal |
| <img src="https://upload.wikimedia.org/wikipedia/commons/e/e4/Tmux_logo.svg" width="20"> | **[Tmux](https://github.com/tmux/tmux)** | Terminal multiplexer |
| <img src="https://www.vectorlogo.zone/logos/neovimio/neovimio-icon.svg" width="20"> | **[Neovim](https://neovim.io/)** | Modern Vim with LSP |
| <img src="https://avatars.githubusercontent.com/u/42918198" width="20"> | **[ASDF](https://asdf-vm.com/)** | Version manager for everything |
| <img src="https://brew.sh/assets/img/homebrew-256x256.png" width="20"> | **[Homebrew](https://brew.sh/)** | macOS package manager |

### Repository Structure

```
~/.dotfiles/
├── Makefile                    # Main installer
├── config/
│   └── kitty/                  # Kitty terminal
│       ├── kitty.conf          # Main config
│       ├── conf.d/             # Modular: fonts, keys, macos
│       └── themes/             # Color themes
├── profile/
│   ├── zshrc                   # ZSH main config
│   ├── zsh.d/                  # Modular ZSH configs
│   │   ├── env.zsh             # Environment & PATH
│   │   ├── plugins.zsh         # Zinit plugins
│   │   ├── alias.zsh           # Shell aliases
│   │   └── ...                 # More modules
│   ├── nvim/                   # Neovim (Lua-based)
│   │   ├── init.lua            # Entry point
│   │   └── lua/
│   │       ├── config/         # Options, keymaps
│   │       └── plugins/        # LSP, treesitter, etc.
│   ├── tmux.conf               # Tmux base config
│   ├── tmux.local              # Tmux customizations
│   ├── gitconfig               # Git configuration
│   └── editorconfig            # Editor settings
├── tools/
│   └── Makefile                # ASDF tool installer
├── scripts/                    # Utility scripts
│   ├── dclean                  # Docker cleanup
│   ├── kleanup                 # Kubernetes cleanup
│   └── passwdgen               # Password generator
└── doc/                        # Documentation
```

---

## Documentation

Detailed documentation for each component:

| Document | Description |
|:---------|:------------|
| **[ZSH](doc/zsh.md)** | Shell configuration, plugins, and aliases |
| **[Neovim](doc/nvim.md)** | Editor setup, LSP, keybindings |
| **[Tmux](doc/tmux.md)** | Multiplexer keybindings and theme |
| **[Kitty](doc/kitty.md)** | Terminal settings and shortcuts |

---

## Customization

<details>
<summary><strong>Change Neovim Theme</strong></summary>

Edit `profile/nvim/lua/plugins/editor.lua`:

```lua
-- Switch from Dracula to TokyoNight
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = { style = "night" },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
},
```
</details>

<details>
<summary><strong>Add ZSH Aliases</strong></summary>

Edit `profile/zsh.d/alias.zsh`:

```bash
# Add your custom aliases
alias myalias='command here'
```
</details>

<details>
<summary><strong>Change Kitty Theme</strong></summary>

Edit `config/kitty/kitty.conf`:

```conf
# Available: dracula, tokyonight, nord, material-dark
include themes/tokyonight.conf
```
</details>

<details>
<summary><strong>Modify Tmux Theme</strong></summary>

Edit `profile/tmux.local` to customize colors and status bar.
</details>

---

## Make Commands

### Main Makefile

```bash
make help       # Show all available targets
make all        # Install everything
make brew       # Install Homebrew
make asdf       # Install ASDF
make profile    # Install shell/editor configs
make tools      # Install dev tools
make kitty      # Install Kitty terminal
```

### Tools Makefile (`tools/`)

```bash
make all         # Python, Node.js, Go, Terraform, K8s
make python      # Python (latest)
make nodejs      # Node.js (latest)
make golang      # Go (latest)
make terraform   # Terraform
make kubernetes  # kubectl, helm, kind, kubectx
make list        # List installed tools
make update      # Update ASDF plugins
```

---

## Utility Scripts

| Script | Description |
|:-------|:------------|
| `dclean` | Remove stopped Docker containers, dangling images & volumes |
| `kleanup` | Clean up old Kubernetes ReplicaSets, completed Jobs, evicted Pods |
| `passwdgen [len]` | Generate random passwords (default: 32 chars) |

---

## Troubleshooting

<details>
<summary><strong>Reload configurations</strong></summary>

```bash
# ZSH
source ~/.zshrc

# Neovim plugins
nvim +"Lazy sync" +qa

# Tmux
tmux source-file ~/.tmux.conf

# Kitty (or press Cmd+Shift+,)
kill -SIGUSR1 $(pgrep kitty)
```
</details>

<details>
<summary><strong>Reset Neovim</strong></summary>

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
nvim  # Fresh start
```
</details>

<details>
<summary><strong>Profile ZSH startup time</strong></summary>

```bash
time zsh -i -c exit
```
</details>

---

## Acknowledgments

Inspired by and built upon the work of:

- [gpakosz/.tmux](https://github.com/gpakosz/.tmux) - Tmux configuration
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) - macOS dotfiles inspiration
- [holman/dotfiles](https://github.com/holman/dotfiles) - Organization patterns
- [folke](https://github.com/folke) - Neovim plugin ecosystem

---

<div align="center">

**[Back to top](#dotfiles)**

Made with care by [Javier Coscolla](https://github.com/jcc-tck)

</div>
