# ZSH Configuration

ZSH shell setup using Zinit as plugin manager. Entry point is `zshrc`, which sources 11 modules in order from `zsh.d/`.

## Loading Order

```
zshrc
  └─ tmux auto-start (login shells, skips VS Code)
  └─ Zinit bootstrap
  └─ env.zsh          — Homebrew PATH, locale, EDITOR
  └─ options.zsh      — AUTO_CD, PUSHD, completion opts
  └─ history.zsh      — HISTSIZE=10000, SHARE_HISTORY, dedup
  └─ plugins.zsh      — Zinit plugins (turbo mode)
  └─ prompt.zsh       — gitstatus prompt
  └─ completion.zsh   — zstyle completion config
  └─ colors.zsh       — LS_COLORS
  └─ kitty.zsh        — Kitty terminal integration
  └─ alias.zsh        — Shell aliases
  └─ tools.zsh        — ASDF, fzf, bat, zoxide
  └─ claude.zsh       — Claude Code / AWS Bedrock (untracked)
  └─ direnv hook      — deferred via precmd
```

## Plugins (Zinit Turbo Mode)

| Plugin | Load Mode | Purpose |
|--------|-----------|---------|
| `romkatv/gitstatus` | sync | Git prompt (required before prompt renders) |
| `zsh-users/zsh-completions` | `wait'0'` | Extended completions |
| `zsh-users/zsh-autosuggestions` | `wait'0'` | History/completion suggestions |
| `zdharma-continuum/fast-syntax-highlighting` | `wait'0'` | Syntax highlight + compinit |
| `zdharma-continuum/history-search-multi-word` | `wait'0'` | Multi-word history search |
| `superbrothers/zsh-kubectl-prompt` | `wait'1'` | K8s context (only if kubectl exists) |
| fzf key bindings + completions | `wait'1'` | Sourced from Homebrew fzf path |

`compinit` is handled by Zinit via `zicompinit` inside `fast-syntax-highlighting`'s `atinit` hook. `bashcompinit` is deferred via a `precmd` hook for ~20ms speedup.

## Prompt System

`zsh.d/prompt.zsh` builds the prompt with two backends:

- **Primary:** `gitstatus` (romkatv) — async, ~10x faster than vcs_info
- **Fallback:** `vcs_info` — used if `gitstatus_query` is not found

All prompt variables are `typeset -g` at the top of the file and are the only customization interface. There is no separate config file.

### Prompt Variables

| Variable | Default | Controls |
|----------|---------|---------|
| `PROMPT_COLOR_DIR` | 31 | Directory path color |
| `PROMPT_COLOR_GIT_BRANCH` | 76 | Git branch name color |
| `PROMPT_COLOR_GIT_STAGED` | 76 | Staged indicator color |
| `PROMPT_COLOR_GIT_UNSTAGED` | 178 | Unstaged indicator color |
| `PROMPT_COLOR_GIT_UNTRACKED` | 160 | Untracked indicator color |
| `PROMPT_COLOR_KUBECTL` | 134 | Kubectl context color |
| `PROMPT_SHOW_GIT` | `true` | Toggle git info segment |
| `PROMPT_SHOW_VIRTUALENV` | `true` | Toggle virtualenv segment |
| `PROMPT_SHOW_KUBECTL` | `true` | Toggle kubectl context segment |

Right prompt shows virtualenv/conda and kubectl context. Kubectl context is cached by `~/.kube/config` mtime using macOS `stat -f %m`.

## Key Aliases

| Alias | Expands to | Notes |
|-------|-----------|-------|
| `ls` | `/bin/ls -G` | Native only — avoids lsd iCloud timeout |
| `lsl` / `lsll` / `lslt` | lsd variants | Explicit when safe to use |
| `cat` | `bat --paging=never` | Syntax-highlighted cat |
| `grep` | `rg` | ripgrep |
| `find` | `fd` | fd-find |
| `vi` / `vim` | `nvim` | Neovim |
| `brewup` | full brew upgrade cycle | update + upgrade + cleanup |
| `g` / `gs` / `gst` / `ga` / `gc` / `gp` | git shortcuts | standard git ops |
| `t` / `ta` / `tn` / `tl` / `tk` | tmux shortcuts | session management |

## Environment (env.zsh)

- `HOMEBREW_PREFIX` is hardcoded based on architecture (`/opt/homebrew` arm64, `/usr/local` intel) to avoid slow `brew --prefix` calls at startup
- `EDITOR` and `VISUAL` are both set to `nvim`
- `DOCKER_DEFAULT_PLATFORM` = `linux/amd64`

## fzf

Configured in `tools.zsh`. Uses `fd` as default command when available. Key bindings and completions are lazy-loaded via Zinit from `$HOMEBREW_PREFIX/opt/fzf/shell/`.

```bash
FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border ...'
```

## Profile ZSH Startup

```bash
time zsh -i -c exit
```
