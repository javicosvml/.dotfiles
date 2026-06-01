---
name: tmux-config
description: Tmux configuration expertise - prefix bindings, pbcopy integration, TokyoNight theme
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: configuration
  tags: tmux,terminal,clipboard
---

# Tmux Config Skill

Expert guidance on Tmux configuration for this project. Understand the quirks and best practices specific to this setup.

## Tmux Architecture

### Dual Prefix Setup (GNU Screen Compatible)

```tmux
# Primary prefix: C-b (default, implicit)
# Secondary prefix: C-a (GNU Screen compatible)

set -g prefix2 C-a
bind C-a send-prefix -2
```

**Important:** When creating bindings, you can use either:
```tmux
bind C-b <command>     # Primary prefix
bind C-a <command>     # GNU Screen compatible
bind -T copy-mode-vi y # Works with both prefixes
```

### Clipboard Integration (macOS)

**No tmux-yank plugin!** Uses native pbcopy/pbpaste.

```tmux
# Copy mode: pipe directly to pbcopy
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"

# Enter (also copies)
bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"

# Mouse drag/triple-click auto-copy
bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

# Paste from system clipboard
bind ] paste-buffer -p
```

### Theme: TokyoNight Night

```
#1a1b26 — Background (dark blue-black)
#565f89 — Comment gray (inactive borders, secondary text)
#c0caf5 — Foreground (primary text)
#7aa2f7 — Blue (active borders, accents)
#7dcfff — Cyan (active window, highlights)
#9ece6a — Green (success indicators)
```

## Key Bindings Reference

| Action | Binding | Notes |
|---|---|---|
| Enter copy mode | `C-a [` or `C-b [` | Both prefixes work |
| Start selection | `Space` | In copy mode |
| Copy to clipboard | `y` | In copy-mode-vi |
| Copy & exit | `Enter` | In copy-mode-vi |
| Paste | `C-a ]` or `C-b ]` | Both prefixes |
| Paste (system) | Right-click | Mouse in any pane |
| Select pane | `C-a ↑/↓/←/→` | Arrow keys |
| Resize pane | `C-a C-↑/↓/←/→` | Alt+arrow to resize |
| Create window | `C-a c` or `C-b c` | |
| Kill pane | `C-a x` or `C-b x` | |
| Kill window | `C-a &` or `C-b &` | |

## Common Configuration Patterns

### Adding a New Key Binding

```tmux
# Simple command binding
bind C-x command-prompt -p "run: " -I "make verify"

# Use both prefixes
bind -n C-x send-keys "make verify" Enter  # No prefix needed
bind C-a C-x send-keys "make verify" Enter # With C-a prefix

# For copy mode
bind -T copy-mode-vi g send-keys -X jump-to-prompt
```

### Mouse Support

```tmux
set -g mouse on   # Enable mouse scrolling, pane selection, resizing
```

### Color Configuration

```tmux
# Active window colors
set-window-option -g window-status-current-style "bg=#7dcfff,fg=#1a1b26"

# Inactive window colors
set-window-option -g window-status-style "bg=#565f89,fg=#c0caf5"

# Pane borders
set -g pane-active-border-style "fg=#7aa2f7"
set -g pane-border-style "fg=#565f89"
```

## Troubleshooting

| Problem | Diagnosis | Solution |
|---|---|---|
| `C-a` doesn't work | prefix2 not set | Check: `grep "prefix2 C-a" tmux.conf` |
| Copy doesn't paste | pbcopy binding missing | Validate: `grep "pbcopy" tmux.conf` must have 3+ matches |
| Can't use mouse | Mouse disabled | Add: `set -g mouse on` |
| Colors look wrong | Theme not applied | Check: `grep "#7aa2f7" tmux.conf` |
| Bindings don't work | Syntax error | Run: `tmux source-file -v tmux.conf` |

## Before You Commit

```bash
# Always validate tmux syntax
tmux source-file -v tmux.conf

# Check critical bindings exist
grep "pbcopy" tmux.conf    # Copy binding
grep "pbpaste" tmux.conf   # Paste binding
grep "prefix2 C-a" tmux.conf # Dual prefix
grep "mouse on" tmux.conf  # Mouse support

# Test in a new session
tmux new-session -s test
<test your bindings>
tmux kill-session -t test
```

## Related Documentation

- `tmux.conf` (in repo root)
- `docs/tmux.dotfiles.md` (comprehensive reference)
