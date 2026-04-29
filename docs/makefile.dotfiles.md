# Makefile Reference

Single-file installer and profile manager for macOS dotfiles. All targets are idempotent.

## Shell Settings

```makefile
SHELL := /bin/bash
.SHELLFLAGS := -e -u -o pipefail -c
```

Strict mode: any undefined variable or failed command aborts the build.

## Installation Chain

`make all` runs these targets in sequence:

```
check-xcode → brew → asdf → profile → tools → kitty
```

`profile` expands to: `zsh neovim tmux git`

`tools` expands to: `brew-tools nodejs golang terraform kubernetes`

`kubernetes` expands to: `kubectl helm kind kubectx`

## All Targets

### Main

| Target | Description |
|--------|-------------|
| `make help` | List all targets |
| `make verify` | Check Xcode CLT, Homebrew, git, zsh, tmux, nvim, ASDF |
| `make all` | Full install |
| `make brew` | Install Homebrew (auto-detects arm64 vs intel PATH) |
| `make asdf` | Install ASDF from Homebrew |
| `make profile` | Symlink zsh + neovim + tmux + git configs |
| `make tools` | Install brew-tools + nodejs + golang + terraform + kubernetes |
| `make kitty` | Install Kitty + JetBrains Mono font, symlink kitty.conf |
| `make clean` | Remove all symlinks (zshrc, zsh.d, nvim, tmux.conf, kitty.conf, gitignore) |

### Profile

| Target | Symlinks |
|--------|---------|
| `make zsh` | `~/.zshrc` → `zshrc`, `~/.zsh.d` → `zsh.d/` |
| `make neovim` | `~/.config/nvim` → `nvim/` (installs nvim via brew if missing) |
| `make tmux` | `~/.tmux.conf` → `tmux.conf` (depends on `install-tpm`) |
| `make git` | `~/.gitignore_global` → `gitignore_global`, sets `core.excludesfile` |
| `make install-tpm` | Clones TPM to `~/.tmux/plugins/tpm` if not present |

### Development Tools (ASDF)

| Target | Description |
|--------|-------------|
| `make brew-tools` | git, tmux, neovim + wget, curl, jq, yq, gh, git-lfs, bat, lsd, fd, ripgrep, fzf, htop, tree, tldr, zoxide, direnv |
| `make nodejs` | Latest LTS (even major numbers: 20, 22, 24…) via ASDF |
| `make nodejs-update` | Check current vs latest LTS, update if newer available |
| `make golang` | Latest stable Go via ASDF |
| `make ruby` | Latest stable Ruby via ASDF |
| `make terraform` | Latest stable Terraform via ASDF |
| `make kubectl` | Latest kubectl via ASDF |
| `make helm` | Latest Helm via ASDF |
| `make kind` | Latest kind via ASDF (custom plugin URL) |
| `make kubectx` | Latest kubectx via ASDF (custom plugin URL) |
| `make kubernetes` | All k8s tools: kubectl + helm + kind + kubectx |
| `make docker` | Docker Desktop via Homebrew Cask |
| `make aws` | AWS CLI via ASDF |
| `make gcloud` | Google Cloud SDK via Homebrew Cask |
| `make azure` | Azure CLI via Homebrew |
| `make list` | `asdf current` — show all installed tool versions |
| `make update` | `brew upgrade asdf` + `asdf plugin update --all` |

## Reusable Macros

Two `define` macros handle all ASDF tool installations:

- **`install_plugin`** — adds an ASDF plugin if not already present; accepts an optional custom URL
- **`install_tool`** — calls `check_asdf` + `install_plugin`, then installs the latest version via `asdf latest` and sets it as global with `asdf set --home`

Node.js uses its own logic because LTS detection requires filtering for even major versions.

## Backup Behavior

All `make profile` targets back up existing non-symlink configs before overwriting:

```
~/.zshrc        → ~/.zshrc.backup
~/.zsh.d/       → ~/.zsh.d.backup/
~/.config/nvim/ → ~/.config/nvim.backup/
~/.tmux.conf    → ~/.tmux.conf.backup
```

## Variables

| Variable | Value |
|----------|-------|
| `DOTFILES` | `$(HOME)/.dotfiles` |
| `CONFIG_DIR` | `$(HOME)/.config` |
| `KITTY_CONFIG` | `$(HOME)/.config/kitty` |
| `OS` | `$(shell uname -s)` |
