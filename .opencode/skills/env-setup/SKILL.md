---
name: env-setup
description: Installation order, prerequisites, troubleshooting, and environment setup guide
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: installation-setup
  tags: setup,installation,prerequisites
---

# Environment Setup Skill

Complete guide to setting up this dotfiles project from scratch.

## Prerequisites Check

Before running any installation, verify you have:

```bash
# 1. macOS version (Ventura or later recommended)
sw_vers -productVersion  # Should be 10.13 or higher

# 2. Terminal with ANSI support (Kitty, Alacritty, WezTerm, Ghostty, etc.)
echo $TERM  # Should NOT be "dumb"

# 3. Git
git --version

# 4. Xcode Command Line Tools
xcode-select -p  # If missing, next step will prompt to install
```

## Installation Order (Critical)

The `make all` target enforces this order. **Do not skip steps or reorder.**

### Step 1: Xcode Command Line Tools (Blocking)

```bash
make check-xcode
```

**What happens:**
- Checks if Xcode CLT is installed
- If missing: Shows dialog "Install Xcode Command Line Tools?"
- You must click "Install" and wait for completion (~30 min on first install)
- Then re-run the command

**Why it matters:** Required for git, compiler, and build tools.

### Step 2: Homebrew (Package Manager)

```bash
make brew
```

**What happens:**
- Installs Homebrew if missing
- Adds Homebrew to PATH in `~/.zprofile` (for both Intel and Apple Silicon)
- May prompt for admin password

**Why it matters:** Everything else installs via Homebrew (or through it).

**Note:** If you're on Apple Silicon (M1/M2/M3), Homebrew installs to `/opt/homebrew`. On Intel, `/usr/local`.

### Step 3: mise (Version Manager)

```bash
make mise
```

**What happens:**
- Installs mise via Homebrew
- Replaces ASDF (older version manager)
- Manages Node.js, Go, Ruby, Terraform versions

**Why it matters:** Allows multiple versions of languages side-by-side.

**Note:** `make all` automatically initializes mise in PATH via `tools.zsh`.

### Step 4: Profile (Symlink All Configs)

```bash
make profile
```

**What happens:**
- Symlinks zshrc → ~/.zshrc
- Symlinks zsh.d → ~/.zsh.d
- Symlinks nvim → ~/.config/nvim
- Symlinks tmux.conf → ~/.tmux.conf
- Symlinks gitignore_global → ~/.gitignore_global
- Symlinks kitty.conf → ~/.config/kitty/kitty.conf
- Backs up existing configs to .backup if present

**Why it matters:** Makes your shell, editor, and tools use the dotfiles.

**After this:** Restart terminal or `source ~/.zshrc`

### Step 5: Tools (CLI Utilities)

```bash
make tools
```

**What happens:**
- Installs: bat, lsd, fd, ripgrep, fzf, htop, tree, tldr, zoxide, direnv, etc.
- All installed via Homebrew
- Sets up shell integrations (fzf, zoxide)

**Why it matters:** Provides modern CLI alternatives to standard tools.

**Note:** Some of these (like lsd, fzf) are referenced in aliases and shell integrations.

### Step 6: Kitty Terminal (Optional but Recommended)

```bash
make kitty
```

**What happens:**
- Installs Kitty terminal app via Homebrew Cask
- Installs JetBrains Mono font
- Symlinks kitty.conf

**Why it matters:** TokyoNight theme is optimized for Kitty.

**Alternative:** Use any terminal with 24-bit color support (Alacritty, WezTerm, etc.).

## Quick Setup (All at Once)

```bash
cd ~/.dotfiles
make verify     # Check current state
make all        # Full installation
source ~/.zshrc # Reload shell
make verify     # Verify installation succeeded
```

**Time:** ~10-30 minutes depending on internet speed and existing Homebrew cache.

## Troubleshooting

### "Xcode Command Line Tools Not Found"

```bash
# Solution: Install via command line
xcode-select --install

# Or reset to default
sudo xcode-select --reset

# Verify
xcode-select -p  # Should show /Applications/Xcode.app/...
```

### "Homebrew Not in PATH"

```bash
# Check shell startup files
cat ~/.zprofile | grep brew

# If missing, manually add:
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

# Reload
source ~/.zprofile
```

### "ZSH Syntax Error After Setup"

```bash
# Validate all ZSH modules
bash scripts/validate-configs.sh

# Check specific module
zsh -n ~/.zsh.d/plugins.zsh

# If error found, check that module file
cat ~/.zsh.d/plugins.zsh | head -50
```

### "Tmux Won't Start"

```bash
# Check syntax
tmux source-file -v ~/.tmux.conf

# If error, restart manually
tmux kill-server
tmux new-session -s main
```

### "PATH Is Broken"

```bash
# Check current PATH
echo $PATH

# Check what's in tools.zsh
grep "export PATH" ~/.zsh.d/tools.zsh

# Reset (source env.zsh in new shell)
zsh -c 'source ~/.zsh.d/env.zsh && echo $PATH'

# If still broken, check HOMEBREW_PREFIX
echo $HOMEBREW_PREFIX
```

### "mise Tools Not Found"

```bash
# Verify mise installed
mise --version

# Check installed tools
mise ls

# If empty, install some:
make nodejs
make golang

# If "mise: command not found", reload shell
source ~/.zshrc
```

### "Symlink Conflicts"

```bash
# Check what's symlinked
ls -l ~/.zshrc     # Should show -> ~/.dotfiles/zshrc
ls -l ~/.zsh.d     # Should show -> ~/.dotfiles/zsh.d

# If not symlinks (regular files), remove and reinstall
rm ~/.zshrc ~/.zsh.d
make profile
```

## Individual Component Setup

If you only want to set up specific tools:

```bash
# Just ZSH
make zsh

# Just Tmux (with TPM plugin manager)
make tmux

# Just Neovim
make neovim

# Just Git config
make git

# Just CLI tools (no languages)
make brew-tools
```

## Post-Installation Verification

```bash
# 1. Check system state
make verify

# 2. Check ZSH works
zsh -c 'echo $SHELL'

# 3. Check Tmux works
tmux new-session -d -s test && tmux kill-session -t test

# 4. Check Neovim works
nvim --version

# 5. Check PATH
echo $PATH | tr ':' '\n'

# 6. Check git
git --version
```

## Updating Everything

```bash
# Update mise and all managed tools
make update

# Update Homebrew packages
brew upgrade

# Update Neovim plugins
nvim +"Lazy update" +qa

# Update configurations
make profile

# Reload shell
source ~/.zshrc
```

## Uninstalling

To completely remove dotfiles setup:

```bash
# Remove all symlinks (but keep .backup files)
make clean

# Manually remove backups if desired
rm -f ~/.zshrc.backup ~/.zsh.d.backup ~/.tmux.conf.backup ~/.config/nvim.backup

# Restore system defaults (optional)
cd ~
git clone https://github.com/javicosvml/.dotfiles.git ~/.dotfiles  # Restore repo
```

## Starting Fresh on New Machine

```bash
# 1. Clone repo
cd ~
git clone https://github.com/javicosvml/.dotfiles.git ~/.dotfiles

# 2. Enter repo
cd ~/.dotfiles

# 3. Run full setup
make all

# 4. Reload shell
source ~/.zshrc

# 5. Verify
make verify
```

## Related Documentation

- `Makefile` (source of truth for all targets)
- `README.md` (quick start section)
- `docs/makefile.dotfiles.md` (Makefile reference)
- `AGENTS.md` (critical quirks and constraints)
