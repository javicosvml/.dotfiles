---
name: zsh-modules
description: ZSH module loading order, PATH setup, plugin management with Zinit
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: configuration
  tags: zsh,shell,plugins
---

# ZSH Modules Skill

Master the 11-module ZSH architecture and understand how to extend it safely.

## Module Loading Order (STRICT)

`zshrc` is the entry point. It bootstraps Zinit, then sources 11 modules in this exact order:

```
1.  env.zsh          → Environment variables, PATH, HOMEBREW_PREFIX
2.  options.zsh      → ZSH options (navigation, completion behavior)
3.  history.zsh      → History configuration (size, format, sharing)
4.  plugins.zsh      → Zinit plugins and themes (deferred loading)
5.  prompt.zsh       → Custom prompt (uses gitstatus, not vcs_info)
6.  completion.zsh   → Autocompletion settings
7.  colors.zsh       → Color schemes (ls color environment)
8.  kitty.zsh        → Kitty terminal integration
9.  alias.zsh        → Aliases (git, tmux, lsd, bat, etc.)
10. tools.zsh        → Integration hub (ASDF/mise, fzf, bat, Docker, zoxide)
11. claude.zsh       → Claude Code / AWS Bedrock config (UNTRACKED)
```

**Critical:** This order cannot change. Later modules depend on earlier ones being loaded first.

## Module Responsibilities

### 1. env.zsh (Environment)
```bash
# Purpose: Set up PATH, environment variables, system defaults
# Key exports:
export EDITOR=nvim
export HOMEBREW_PREFIX=$(brew --prefix)
export PATH="$HOMEBREW_PREFIX/bin:$PATH"
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
```

**Rule:** All PATH manipulation starts here. Don't scatter it across modules.

### 2. options.zsh (Shell Options)
```bash
# Purpose: Configure ZSH behavior (navigation, history, globbing)
setopt NO_CASE_GLOB
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt AUTO_PUSHD
```

**Rule:** Options are orthogonal to plugins. Keep them here.

### 3. history.zsh (History)
```bash
# Purpose: History file format, deduplication, expiry
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
```

**Rule:** All history-related config here, not in options.zsh.

### 4. plugins.zsh (Zinit Plugins)
```bash
# Purpose: Load Zinit plugins (deferred, non-blocking)
# Uses Zinit for fast plugin management
# Plugins are "sourced" here, not in other modules
```

**Rule:** All plugin loading via Zinit. Don't source files directly in other modules (except config files).

### 5. prompt.zsh (Prompt)
```bash
# Purpose: Custom prompt with gitstatus (fast git info)
# Uses gitstatus (~47ms) instead of vcs_info
# Customizable via PROMPT_* variables at the top of the file
typeset -g PROMPT_PREFIX="┌─ "
typeset -g PROMPT_SUFFIX="└─ "
```

**Rule:** Edit `PROMPT_*` variables directly. No separate config file exists.

### 6. completion.zsh (Completion)
```bash
# Purpose: Autocompletion configuration
# Deferred loading for performance
# Works with plugins.zsh Zinit setup
```

**Rule:** Completion setup here. Specific completions in plugins.zsh.

### 7. colors.zsh (Colors)
```bash
# Purpose: LS color environment, theme colors
export LS_COLORS="..."
```

**Rule:** All color setup here. Color schemes for Kitty/Tmux live elsewhere.

### 8. kitty.zsh (Terminal)
```bash
# Purpose: Kitty terminal integration (shell integration, image protocol)
# Loads Kitty shell integration if available
```

**Rule:** Terminal-specific setup here. Other terminals stay isolated.

### 9. alias.zsh (Aliases)
```bash
# Important aliases:
alias lsd='lsd'           # List with colors (if safe)
alias lsl='lsd -l'        # Long format
alias bat='bat'           # Code viewer
alias cd='z'              # zoxide for faster cd
```

**Rule:** All aliases here. Never scatter them across modules.

**Special Case:** `ls` still uses native `/bin/ls -G` to avoid iCloud timeouts (`os error 60`).

### 10. tools.zsh (Integration Hub)
```bash
# Purpose: Critical integrations that must load after env/options/aliases
# Includes:
#   - ASDF/mise initialization (version managers)
#   - fzf configuration
#   - bat theme setup
#   - zoxide initialization
#   - Docker context
#   - direnv hook
```

**Rule:** This is the integration hub. Changes here affect PATH, aliases, and shell behavior downstream.

**Warning:** If you modify PATH or export variables here, they affect EVERYTHING downstream.

### 11. claude.zsh (Claude Code)
```bash
# Purpose: Claude Code / AWS Bedrock configuration
# Contains AWS_REGION, ANTHROPIC_MODEL, etc.
# This file is UNTRACKED (in .gitignore)
```

**Rule:** Never commit this file. Contains sensitive model ARNs.

## Adding New Functionality

### Scenario 1: New Shell Option
→ Add to `options.zsh`

### Scenario 2: New Environment Variable
→ Add to `env.zsh`

### Scenario 3: New Plugin
→ Add to `plugins.zsh` via Zinit

### Scenario 4: New Alias
→ Add to `alias.zsh`

### Scenario 5: New Tool Integration (fzf, zoxide, etc.)
→ Add to `tools.zsh`

### Scenario 6: Customize Prompt
→ Edit `PROMPT_*` variables at top of `prompt.zsh`

## Common Mistakes

| Mistake | Impact | Fix |
|---|---|---|
| Modifying loading order | PATH breaks, plugins fail to load | Don't. Order is immutable. |
| Scattering aliases across modules | Hard to find, poor organization | Keep all in alias.zsh |
| Adding PATH to tools.zsh too late | Dependencies can't find executables | Add to env.zsh instead |
| Editing claude.zsh | Breaks AWS Bedrock config, accidental commit | Don't edit. Use zsh.d/claude.zsh only. |
| Sourcing files in wrong place | Timing issues, incomplete initialization | Follow module responsibilities. |
| Reordering modules in zshrc | Everything breaks silently | Never. Order is sacred. |

## Validation

```bash
# Check all 11 modules exist
ls -1 ~/.zsh.d/*.zsh | wc -l  # Should be 11 (or 12 with claude)

# Validate syntax
for file in ~/.zsh.d/*.zsh; do
  zsh -n "$file" || echo "Error in $file"
done

# Check loading order in zshrc
grep "source.*\.zsh.d/" ~/.zshrc
```

## Documentation

- `zshrc` (entry point, shows loading order)
- `zsh.d/` (individual modules)
- `docs/zsh.dotfiles.md` (comprehensive reference)
