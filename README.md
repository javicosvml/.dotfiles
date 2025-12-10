<div align="center">

![Death](img/whatrudoing.png)

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
- **Parametrizable prompt** with [gitstatus](https://github.com/romkatv/gitstatus) (~47ms startup)
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
| **Modular Design** | Organized configs with `zsh.d/` includes and flat structure |
| **One-Command Install** | Get up and running with a single `make` command |
| **Modern CLI Tools** | `bat`, `lsd`, `fd`, `ripgrep`, `fzf` aliases built-in |
| **Auto-Tmux** | Automatically attaches to tmux session on login |
| **Optimized Performance** | ~47ms ZSH startup with intelligent caching |

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

# 4. Install development tools (Node.js, Go, Terraform, etc.)
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
| <img src="https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/prompt-styles-high-contrast.png" width="20"> | **[gitstatus](https://github.com/romkatv/gitstatus)** | Ultra-fast parametrizable prompt (~47ms) |
| <img src="https://sw.kovidgoyal.net/kitty/_static/kitty.svg" width="20"> | **[Kitty](https://sw.kovidgoyal.net/kitty/)** | GPU-accelerated terminal |
| <img src="https://upload.wikimedia.org/wikipedia/commons/e/e4/Tmux_logo.svg" width="20"> | **[Tmux](https://github.com/tmux/tmux)** | Terminal multiplexer |
| <img src="https://www.vectorlogo.zone/logos/neovimio/neovimio-icon.svg" width="20"> | **[Neovim](https://neovim.io/)** | Modern Vim with LSP |
| <img src="https://avatars.githubusercontent.com/u/42918198" width="20"> | **[ASDF](https://asdf-vm.com/)** | Version manager for everything |
| <img src="https://brew.sh/assets/img/homebrew-256x256.png" width="20"> | **[Homebrew](https://brew.sh/)** | macOS package manager |

### Repository Structure

```
~/.dotfiles/
├── Makefile                    # Unified installer (main + tools + profile)
├── Dockerfile                  # Docker test environment
├── init.sh                     # Complete test suite
├── zshrc                       # ZSH entry point → ~/.zshrc
├── zsh.d/                      # Modular ZSH → ~/.zsh.d/
│   ├── env.zsh                 # Environment & PATH
│   ├── plugins.zsh             # Zinit plugins
│   ├── alias.zsh               # Shell aliases
│   ├── tools.zsh               # Tool integrations (ASDF, etc.)
│   └── ...                     # More modules
├── nvim/                       # Neovim → ~/.config/nvim
│   ├── init.lua                # Entry point
│   ├── lazy-lock.json          # Plugin lockfile
│   └── lua/
│       ├── config/             # Options, keymaps, autocmds
│       └── plugins/            # LSP, treesitter, editor, completion
├── kitty.conf                  # Kitty terminal → ~/.config/kitty/kitty.conf
├── tmux.conf                   # Tmux config → ~/.tmux.conf
└── gitignore_global            # Global gitignore → ~/.gitignore_global
```

---

---

## Customization

<details>
<summary><strong>Change Neovim Theme</strong></summary>

Edit `nvim/lua/plugins/editor.lua`:

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
<summary><strong>Customize ZSH Prompt</strong></summary>

The prompt is fully parametrizable with 40+ configuration variables. Copy the example config and customize:

```bash
cp ~/.zsh.d/prompt.config.example ~/.zsh.d/prompt.config
vim ~/.zsh.d/prompt.config  # Edit colors, symbols, visibility
source ~/.zshrc
```

**Included presets**: Minimal, Nord, Dracula, Gruvbox, Solarized

See [zsh.d/prompt.config.example](zsh.d/prompt.config.example) for full documentation.
</details>

<details>
<summary><strong>Add ZSH Aliases</strong></summary>

Edit `zsh.d/alias.zsh`:

```bash
# Add your custom aliases
alias myalias='command here'
```
</details>

<details>
<summary><strong>Change Kitty Theme</strong></summary>

Edit `kitty.conf` and modify the color scheme section:

```conf
# =============================================================================
# Color Scheme - TokyoNight Night
# =============================================================================
# Change colors to your preferred theme
```
</details>

<details>
<summary><strong>Modify Tmux Configuration</strong></summary>

Edit `tmux.conf` directly to customize your tmux setup.
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

### Development Tools

```bash
make tools       # Install essential dev tools
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

## Testing & Validation

### Automated Test Suite with Docker

The repository includes a comprehensive test suite (`init.sh`) that validates integrity and functionality in an Ubuntu environment:

**Quick Start:**

```bash
# Build and run complete test suite
docker build -t dotfiles-test .
docker run --rm dotfiles-test
```

**What Gets Tested:**

| Test Category | Description |
|:-------------|:------------|
| **Structure** | Validates all required directories exist |
| **Files** | Checks presence of critical configuration files |
| **Syntax** | Validates Makefile, ZSH, and Lua syntax |
| **Permissions** | Verifies file read permissions |
| **Targets** | Tests all Makefile target definitions |
| **Execution** | Runs portable targets (`profile`, `zsh`, `neovim`, `tmux`, `git`) |
| **Symlinks** | Verifies correct symlink creation |
| **Post-Install** | Validates installed configurations |
| **Cleanup** | Tests cleanup target (dry-run) |

**Interactive Exploration:**

```bash
# Open shell in test environment
docker run --rm -it dotfiles-test /bin/zsh

# Run tests manually
docker run --rm -it dotfiles-test bash
./dotfiles/init.sh
```

**CI/CD Integration:**

```yaml
# Example GitHub Actions workflow
- name: Test Dotfiles
  run: |
    docker build -t dotfiles-test .
    docker run --rm dotfiles-test
```

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

## Documentation

| Document | Purpose |
|:---------|:--------|
| **[README.md](README.md)** | This file - user-facing setup guide |
| **[CLAUDE.md](CLAUDE.md)** | AI assistant guidance & development patterns |
| **[HISTORY.md](HISTORY.md)** | Detailed changelog with technical specifics |
| **[zsh.d/prompt.config.example](zsh.d/prompt.config.example)** | Prompt customization guide with 5 themes |

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
