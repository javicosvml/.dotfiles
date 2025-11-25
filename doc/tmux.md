<div align="center">

# Tmux Configuration

Terminal multiplexer based on [gpakosz/.tmux](https://github.com/gpakosz/.tmux) with Dracula theme

[Structure](#structure) •
[Keybindings](#keybindings) •
[Status Bar](#status-bar) •
[Commands](#commands)

</div>

---

## Structure

```
profile/
├── tmux.conf       # Base config (gpakosz/.tmux) → ~/.tmux.conf
└── tmux.local      # Local customizations → ~/.tmux.conf.local
```

---

## Prefix Key

| Key | Note |
|:----|:-----|
| **`Ctrl+B`** | Primary prefix |
| **`Ctrl+A`** | Alternative prefix |

---

## Keybindings

### Sessions

| Key | Action |
|:----|:-------|
| `<prefix> d` | Detach from session |
| `<prefix> C-c` | Create new session |
| `<prefix> $` | Rename session |

### Windows

| Key | Action |
|:----|:-------|
| `<prefix> c` | New window |
| `<prefix> ,` | Rename window |
| `<prefix> &` | Kill window |
| `<prefix> n` / `p` | Next/Previous window |
| `Alt + ←/→` | Previous/Next (no prefix) |

### Panes

| Key | Action |
|:----|:-------|
| `<prefix> \|` | Split horizontal |
| `<prefix> -` | Split vertical |
| `<prefix> x` | Kill pane |
| `<prefix> z` | Zoom (fullscreen toggle) |
| `<prefix> h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl + h/j/k/l` | Navigate panes (vim-aware, no prefix) |

### Copy Mode

| Key | Action |
|:----|:-------|
| `<prefix> [` | Enter copy mode |
| `v` | Begin selection |
| `y` | Copy selection |
| `<prefix> ]` | Paste |

### Miscellaneous

| Key | Action |
|:----|:-------|
| `<prefix> ?` | List all keybindings |
| `<prefix> r` | Reload configuration |
| `<prefix> e` | Edit local config |
| `<prefix> m` | Toggle mouse support |

---

## Status Bar

```
💀 session     windows...     🔌 85% 🦊 14:30 ♠ 25-Nov
```

| Element | Description |
|:--------|:------------|
| 💀 session | Current session name |
| windows | Window list |
| 🔌 85% | Battery indicator |
| 🦊 14:30 | Time |
| ♠ 25-Nov | Date |

---

## Auto-start

ZSH automatically attaches to tmux session `main` on login.

> **Note:** Disabled in VS Code integrated terminal.

---

## Commands

### Session Management

```bash
# Create new session
tmux new -s name

# List sessions
tmux ls

# Attach to session
tmux attach -t name

# Kill session
tmux kill-session -t name
```

### Configuration

```bash
# Reload config
tmux source-file ~/.tmux.conf
```

---

## Customization

Edit `~/.dotfiles/profile/tmux.local` to customize:
- Colors and theme
- Status bar elements
- Additional keybindings

---

<div align="center">

[Back to README](../README.md)

</div>
