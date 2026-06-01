# AGENTS.md

Agent-focused guidance for working in this macOS dotfiles repository. Every entry answers: "Would an agent likely miss this?"

## What This Repo Is

Personal macOS development dotfiles. All components symlink into `~/.zshrc`, `~/.zsh.d/`, `~/.config/nvim/`, `~/.tmux.conf`, and `~/.config/kitty/`. macOS-only. Single source of truth is `Makefile`.

## Critical Commands (Agents Often Miss)

```bash
make verify              # ALWAYS run before editing config — checks deps and system state
make all                 # Full install: Xcode → Homebrew → mise → profile → tools → Kitty
make profile             # Symlink only (zsh, neovim, tmux, git) — faster than `make all`
bash scripts/validate-configs.sh  # Validates tmux syntax, ZSH modules, clipboard

# After edits, reload without re-running install:
source ~/.zshrc
tmux source-file ~/.tmux.conf
nvim +"Lazy sync" +qa
```

**Why:** Agents often re-run full installs when `make profile` suffices. Config validation is critical before committing.

## Installation Order Matters

`make all` chains these targets in order. Each is idempotent but order is enforced:

1. `check-xcode` → Xcode CLT (blocking dialog may appear)
2. `brew` → Homebrew
3. `mise` → Version manager (replaces ASDF)
4. `profile` → Symlink configs
5. `tools` → CLI utilities (bat, lsd, fd, ripgrep, fzf, zoxide, etc.)
6. `kitty` → Kitty terminal + JetBrains Mono

**Why:** Later stages depend on earlier stages being present. Do not skip or reorder.

## Configuration Validation is Strict

Pre-commit hooks (`.pre-commit-config.yaml`) block commits on:
- ShellCheck on `.sh` files (but **ZSH modules in `zsh.d/` are excluded** — they're sourced, not executed)
- Syntax validation via `scripts/validate-configs.sh` on `tmux.conf`, `zshrc`, `zsh.d/*.zsh`
- YAMLLint, Markdownlint, Typos, Gitleaks

**Why:** Broken config files break the entire environment. Agents must validate before committing.

## ZSH Loading Order is Strict

`zshrc` is the entry point. It auto-starts tmux (login shells only, skips VS Code), bootstraps Zinit, then sources 11 modules from `~/.zsh.d/` in this exact order:

```
env.zsh → options.zsh → history.zsh → plugins.zsh → prompt.zsh →
completion.zsh → colors.zsh → kitty.zsh → alias.zsh → tools.zsh → claude.zsh
```

**Critical:** `tools.zsh` is the integration hub (ASDF/mise, fzf, bat config, zoxide). Changes here affect everything downstream.

**Why:** Out-of-order sourcing breaks PATH, aliases, and shell features. Agents often edit the wrong module or insert code in the wrong place.

## Repository Structure & Ownership

| Path | Purpose | Never Delete |
|------|---------|--------------|
| `zshrc` | Entry point → `~/.zshrc` | **YES** |
| `zsh.d/` | 11 modular config files | **YES** — all 11 required |
| `nvim/` | Neovim config → `~/.config/nvim/` | YES |
| `tmux.conf` | Tmux config → `~/.tmux.conf` | YES |
| `kitty.conf` | Kitty config → `~/.config/kitty/` | YES |
| `gitignore_global` | Global gitignore → `~/.gitignore_global` | YES |
| `Makefile` | Installer & orchestrator | YES |
| `.pre-commit-config.yaml` | Git hooks | YES |
| `scripts/validate-configs.sh` | Config validation | YES |
| `docs/*.dotfiles.md` | Reference docs (per-technology) | NO — reference only |
| `CLAUDE.md` | Claude Code guidance (for Claude Code) | NO — context file |

**Why:** Agents might accidentally delete or skip critical modules, breaking the entire system.

## Quirks That Will Trip Agents

### 1. Tmux Supports `C-a` as Secondary Prefix (GNU Screen-compatible)
Primary prefix is default `C-b`, but `C-a` is set as `prefix2` for GNU Screen compatibility via `send-prefix -2`. Code uses `bind C-a` to support this. All custom bindings should respect this dual-prefix setup.

### 2. Tmux Has Native `pbcopy`/`pbpaste`, No tmux-yank
Copy-mode-vi `y` pipes directly to `pbcopy`. Mouse drag/triple-click also use `pbcopy`. Do not add `tmux-yank` plugin — it conflicts.

### 3. `ls` Uses Native `/bin/ls -G`, Not `lsd`
Native `ls` avoids iCloud/network file timeout issues (`os error 60`). `lsd` available explicitly via `lsl` / `lsll` / `lslt` aliases when safe.

### 4. Prompt Uses `gitstatus`, Not vcs_info
`prompt.zsh` uses **gitstatus** for ~47ms git status (not vcs_info). Falls back to vcs_info if gitstatus unavailable. Fast startup critical.

### 5. Prompt is Parametrized, Not Templated
Customize by editing `PROMPT_*` variables at the top of `zsh.d/prompt.zsh` directly. No separate config file exists.

### 6. `claude.zsh` is Untracked
`zsh.d/claude.zsh` is in `.zshrc` sources but **should not be committed** — it contains AWS Bedrock model ARN and env vars. Agents should never write to it.

### 7. Version Manager: mise (Not ASDF)
Uses `mise` (modern ASDF replacement). Makefile has `mise use --global <tool>@latest`. Language versions: Node.js (LTS even-numbered), Go, Ruby, Terraform.

**Why:** Agents unfamiliar with mise might call ASDF commands. Agents might add `tmux-yank` or change `ls` alias. Agents might edit the wrong prompt variables or commit `claude.zsh`.

## Documentation Policy

- `README.md`: Main docs (Quick Start, Tech Stack, Structure, Usage)
- `docs/*.dotfiles.md`: Per-technology reference (zsh, tmux, neovim, kitty, makefile, mise, github)
- `CLAUDE.md`: Claude Code guidance (detailed version of architecture)
- **Never create other `.md` files** (reports, changelogs, analysis). Only edit these three locations.

**Why:** Agents often create new markdown files instead of updating existing ones.

## How to Verify Work

After any change:

```bash
# 1. Validate syntax
bash scripts/validate-configs.sh

# 2. Verify system state
make verify

# 3. Test a focused component
make zsh          # ZSH only
make tmux         # Tmux only
make neovim       # Neovim only

# 4. Git hooks run automatically before commit
git commit -m "your message"  # Blocks if validation fails
```

**Why:** Agents often skip validation or don't know what commands verify correctness.

## Common Agent Mistakes

1. **Editing wrong module** — Modifying `alias.zsh` when edit should be in `tools.zsh`
2. **Reordering ZSH sources** — Breaks PATH and subsequent modules
3. **Changing tmux prefix or removing pbcopy** — Breaks clipboard workflow
4. **Adding `tmux-yank`** — Conflicts with native bindings
5. **Editing `claude.zsh`** — Should never be committed
6. **Creating new markdown docs** — Should update existing docs only
7. **Running `make all` when `make profile` suffices** — Wastes time
8. **Forgetting `make verify` before changes** — Detects prereq issues early
9. **Not running validation before commit** — Pre-commit hooks catch later
10. **Changing `ls` alias to `lsd`** — Causes network timeouts on iCloud

**Why:** These are real mistakes found in version history and common in multi-session edits.

## Symlink Model

All config files are **symlinked from repo** into home directory:
- `~/.zshrc` → `/Users/javiercoscolla/.dotfiles/zshrc`
- `~/.zsh.d` → `/Users/javiercoscolla/.dotfiles/zsh.d`
- `~/.config/nvim` → `/Users/javiercoscolla/.dotfiles/nvim`
- `~/.tmux.conf` → `/Users/javiercoscolla/.dotfiles/tmux.conf`
- `~/.config/kitty/kitty.conf` → `/Users/javiercoscolla/.dotfiles/kitty.conf`
- `~/.gitignore_global` → `/Users/javiercoscolla/.dotfiles/gitignore_global`

**Why:** Agents should edit files in the repo, not the home directory. Editing `~/.zshrc` directly breaks the symlink.

## Branching & Contributing

- Work on `develop`, merge to `main` via PR
- All changes must pass `make verify` and `bash scripts/validate-configs.sh`
- Pre-commit hooks are enforced — fix issues and retry commit

**Why:** Personal repo but CI/CD enforced. Agents need to know not to force-push or skip validation.
