# Makefile Reference

Single-file installer and profile manager for macOS dotfiles. All targets are idempotent — safe to re-run.

## Installation Chain

`make all` runs these targets en secuencia:

```
check-xcode → brew → mise → profile → tools → kitty
```

- `profile` expands to: `zsh neovim tmux git`
- `tools` expands to: `brew-tools nodejs golang ruby terraform kubernetes`
- `kubernetes` expands to: `kubectl helm kind kubectx`

## All Targets

### Main

| Target | Description |
|--------|-------------|
| `make help` | List all targets with descriptions |
| `make verify` | Check Xcode CLT, Homebrew, git, zsh, tmux, nvim, mise |
| `make all` | Full install: Xcode → Homebrew → mise → profile → tools → Kitty |
| `make profile` | Symlink zsh + neovim + tmux + git configs |
| `make tools` | Install brew-tools + nodejs + golang + ruby + terraform + kubernetes |
| `make clean` | Remove all symlinks |
| `make update` | `brew upgrade` + `mise upgrade` |
| `make list` | `mise ls` — show all managed tool versions |

### Profile (symlinks)

| Target | Symlinks | Notes |
|--------|---------|-------|
| `make zsh` | `~/.zshrc` → `zshrc`, `~/.zsh.d` → `zsh.d/` | Backs up existing non-symlink |
| `make neovim` | `~/.config/nvim` → `nvim/` | Installs nvim via brew if missing |
| `make tmux` | `~/.tmux.conf` → `tmux.conf` | Depends on `install-tpm` |
| `make git` | `~/.gitignore_global` → `gitignore_global`, sets `core.excludesfile` | |
| `make install-tpm` | Clones TPM to `~/.tmux/plugins/tpm` if not present | |

### Packages (Homebrew)

| Target | Installs |
|--------|---------|
| `make brew` | Homebrew (auto-detects arm64 vs Intel PATH) |
| `make kitty` | Kitty terminal + JetBrains Mono font, symlinks `kitty.conf` |
| `make brew-tools` | git, tmux, neovim + bat, lsd, fd, ripgrep, fzf, htop, tree, tldr, zoxide, direnv, wget, curl, jq, yq, gh, git-lfs |

### Runtimes (mise)

Todos los runtimes se instalan via `mise use --global <tool>@latest`:

| Target | Tool | Notes |
|--------|------|-------|
| `make nodejs` | Node.js LTS | Detecta la última versión LTS par (20, 22, 24…) |
| `make nodejs-update` | Node.js LTS | Actualiza si hay versión LTS más nueva disponible |
| `make golang` | Go | Última versión estable |
| `make ruby` | Ruby | Última versión estable |
| `make terraform` | Terraform | Última versión estable |

### Kubernetes y Cloud

| Target | Installs |
|--------|---------|
| `make kubernetes` | kubectl + helm + kind + kubectx (todos via mise) |
| `make kubectl` | kubectl via mise |
| `make helm` | Helm via mise |
| `make kind` | kind via mise |
| `make kubectx` | kubectx via mise |
| `make docker` | Docker Desktop via Homebrew Cask |
| `make aws` | AWS CLI via mise |
| `make gcloud` | Google Cloud SDK via Homebrew Cask |
| `make azure` | Azure CLI via Homebrew |

## Backup Behavior

Todos los targets de `make profile` respaldan configs existentes no-symlink antes de sobrescribir:

```
~/.zshrc        → ~/.zshrc.backup
~/.zsh.d/       → ~/.zsh.d.backup/
~/.config/nvim/ → ~/.config/nvim.backup/
~/.tmux.conf    → ~/.tmux.conf.backup
```

## Variables internas

| Variable | Valor |
|----------|-------|
| `DOTFILES` | `$(HOME)/.dotfiles` |
| `CONFIG_DIR` | `$(HOME)/.config` |
| `KITTY_CONFIG` | `$(HOME)/.config/kitty` |
| `OS` | `$(shell uname -s)` |

## Shell settings

```makefile
SHELL := /bin/bash
.SHELLFLAGS := -e -u -o pipefail -c
```

Strict mode: undefined variable or failed command aborts the build.
