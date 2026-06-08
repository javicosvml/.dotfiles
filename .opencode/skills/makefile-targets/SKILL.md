---
name: makefile-targets
description: Makefile targets reference - what each target does and when to use it
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: installation-setup
  tags: makefile,installation,configuration
---

# Makefile Targets Skill

Quick reference for all Makefile targets and when to use them.

## Main Installation Targets

### `make all`
**Full installation.** Chains: check-xcode → brew → mise → profile → tools → kitty

Use when: First-time setup or complete reinstall
```bash
make all
```

**What it does:**
1. Verifies Xcode CLT (may prompt dialog)
2. Installs Homebrew
3. Installs mise (version manager)
4. Symlinks all configs (profile)
5. Installs CLI tools (bat, lsd, fzf, etc.)
6. Installs Kitty terminal + JetBrains Mono font

### `make profile`
**Symlink configs only.** Much faster than `make all`.

Use when: You've already installed prerequisites, just updating config symlinks
```bash
make profile
```

**What it does:**
- Symlinks zshrc, zsh.d, nvim, tmux.conf, gitignore_global, kitty.conf
- Backs up existing configs to .backup if necessary

**Note:** This is usually what you want when testing config changes.

### `make verify`
**Check system state.** Shows what's installed and what's missing.

Use before making changes to understand current state
```bash
make verify
```

**Output:** Version numbers for Xcode, Homebrew, ZSH, Tmux, Neovim, mise

---

## Component Installation (Individual)

### `make zsh`
Install ZSH configuration only.
```bash
make zsh
```

### `make neovim`
Install Neovim configuration only.
```bash
make neovim
```

### `make tmux`
Install Tmux configuration + TPM (Tmux Plugin Manager).
```bash
make tmux
```

### `make git`
Install Git configuration (gitignore_global).
```bash
make git
```

---

## Dependency Management Targets

### `make brew`
Install Homebrew package manager.

Use when: First time setting up, or Homebrew is missing
```bash
make brew
```

### `make mise`
Install mise (version manager for Node, Go, Ruby, Terraform).

Use when: First time, or need to update mise
```bash
make mise
```

### `make kitty`
Install Kitty terminal + JetBrains Mono font.

Use when: Setting up terminal, or need latest Kitty
```bash
make kitty
```

### `make tools` or `make brew-tools`
Install CLI utilities (bat, lsd, fd, ripgrep, fzf, htop, tree, zoxide, direnv, etc.).

Use when: Want all CLI tools installed
```bash
make tools
make brew-tools  # Alternative name
```

---

## Language/Tool Version Management (mise)

### `make nodejs`
Install Node.js LTS (even-numbered version).
```bash
make nodejs
```

### `make nodejs-update`
Update Node.js to latest LTS.
```bash
make nodejs-update
```

### `make golang` / `make go`
Install Go (latest stable).
```bash
make golang
```

### `make ruby`
Install Ruby (latest stable).
```bash
make ruby
```

### `make terraform`
Install Terraform (latest stable).
```bash
make terraform
```

### `make list`
List all installed mise tools and versions.
```bash
make list
```

### `make update`
Update mise and all managed tools to latest.
```bash
make update
```

---

## Kubernetes / Cloud Tools

### `make kubernetes`
Install all Kubernetes tools (kubectl, helm, kind, kubectx).
```bash
make kubernetes
```

### `make kubectl`
Install kubectl only.
```bash
make kubectl
```

### `make helm`
Install Helm only.
```bash
make helm
```

### `make kind`
Install kind (Kubernetes in Docker).
```bash
make kind
```

### `make docker`
Install Docker Desktop.
```bash
make docker
```

### `make aws`
Install AWS CLI.
```bash
make aws
```

### `make gcloud`
Install Google Cloud SDK.
```bash
make gcloud
```

### `make azure`
Install Azure CLI.
```bash
make azure
```

---

## Cleanup & Help

### `make clean`
Remove all symlinked configs.

Use when: Uninstalling or reverting to system defaults
```bash
make clean
```

**Warning:** This removes symlinks but doesn't delete .backup files.

### `make help`
Show all available targets with descriptions.
```bash
make help
```

---

## Workflow Example

### First-time Setup
```bash
make verify       # Check prerequisites
make all          # Full install
source ~/.zshrc   # Reload shell
make verify       # Verify install succeeded
```

### Testing Config Changes
```bash
make verify       # Check system state
# ... make config changes ...
bash scripts/validate-configs.sh  # Validate syntax
make profile      # Relink if needed
source ~/.zshrc   # Reload shell
```

### Adding a New Tool
```bash
# Install via mise
make go           # Example: install Go

# Or install via Homebrew
make brew-tools   # Updates CLI utilities

# Verify
make verify
```

### Update Everything
```bash
make update       # Update mise + all tools
make profile      # Relink configs in case they changed
source ~/.zshrc
```

---

## Idempotency

All targets are **idempotent** — safe to run multiple times:
- If tool already installed → skips
- If symlink already exists → skips
- If file already backed up → uses existing backup

---

## Order Matters

When running multi-step workflows, respect this order:

1. **check-xcode** (blocks if missing)
2. **brew** (installs Homebrew)
3. **mise** (installs version manager)
4. **profile** (symlinks configs)
5. **tools** (installs CLI utilities)
6. **kitty** (installs terminal)

The `make all` target enforces this order automatically.

---

## Before Committing Changes

```bash
# 1. Verify system
make verify

# 2. Test individual components
make zsh
make tmux
make neovim

# 3. Full validation
bash scripts/validate-configs.sh

# 4. Commit
git add .
git commit -m "..."
```

---

## Documentation

- `Makefile` (source of truth)
- `README.md` (installation section)
- `docs/makefile.dotfiles.md` (comprehensive reference)
