---
name: validate-dotfiles
description: Deep validation workflow for config changes - syntax, architecture, and best practices
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: validation
  tags: testing,quality-assurance
---

# Validate Dotfiles Skill

Use this skill when you need to thoroughly validate configuration changes before committing.

## What This Skill Does

Provides a comprehensive validation checklist and commands to ensure:
- All config files have valid syntax (ZSH, Tmux, Lua)
- Changes respect AGENTS.md constraints
- System dependencies are present
- Symlinks are correctly set up
- Installation order is respected

## Validation Checklist

### 1. Syntax Validation

```bash
# Check ZSH syntax for all modules
for file in zsh.d/*.zsh; do
  echo "Checking $file..."
  zsh -n "$file" || echo "❌ FAILED: $file"
done

# Check Tmux syntax
tmux source-file -v tmux.conf

# Check Neovim Lua syntax (if you have Neovim)
nvim --headless +"Lazy check" +qa

# Run project validation script
bash scripts/validate-configs.sh
```

### 2. System State Verification

```bash
# Check all dependencies
make verify

# Verify symlinks are correct
ls -l ~/.zshrc ~/.zsh.d ~/.config/nvim ~/.tmux.conf ~/.config/kitty/kitty.conf
```

### 3. Architecture Compliance

- [ ] ZSH loading order unchanged (11 modules in exact order)
- [ ] All 11 ZSH modules present (env, options, history, plugins, prompt, completion, colors, kitty, alias, tools, claude)
- [ ] No files deleted from critical paths
- [ ] Tmux prefix C-a (prefix2) intact
- [ ] pbcopy/pbpaste bindings present in tmux.conf
- [ ] claude.zsh not edited or staged
- [ ] No new .md files created (only updates to existing docs)
- [ ] PATH manipulation only in tools.zsh

### 4. Pre-Commit Validation

```bash
# Run pre-commit hooks manually
pre-commit run --all-files

# Or just validate configs
bash scripts/validate-configs.sh
make verify
```

## Full Validation Workflow

```bash
# 1. Quick syntax check
bash scripts/validate-configs.sh

# 2. System verification
make verify

# 3. Test individual components
make zsh      # ZSH only
make tmux     # Tmux only
make neovim   # Neovim only

# 4. Full reload (without reinstalling)
source ~/.zshrc
tmux source-file ~/.tmux.conf
nvim +"Lazy sync" +qa

# 5. Manual spot checks
zsh -i -c "echo \$PATH"          # Check PATH integrity
tmux list-keys | grep "C-a"      # Verify prefix
echo \$EDITOR                     # Check editor variable
```

## When to Use This Skill

- Before committing changes
- After editing config files
- When debugging config issues
- Before running make profile or make all

## What Validates Automatically

Pre-commit hooks (`.pre-commit-config.yaml`) automatically check:
- ShellCheck on .sh files (not zsh.d/)
- tmux.conf syntax
- zshrc and zsh.d/* syntax
- YAML/JSON/TOML syntax
- Markdown linting
- Typos
- Private key detection

## Common Issues & Fixes

| Issue | Cause | Fix |
|---|---|---|
| ZSH syntax error in module | Typo in zsh.d/*.zsh | Run `zsh -n <file>` to find line |
| Tmux won't load | Invalid syntax in tmux.conf | Run `tmux source-file -v tmux.conf` |
| PATH broken | tools.zsh initialization issue | Check HOMEBREW_PREFIX, mise init |
| Symlinks broken | Files edited in ~ instead of repo | Re-run `make profile` |
| claude.zsh error | Accidentally edited it | Restore from git or ignore |
