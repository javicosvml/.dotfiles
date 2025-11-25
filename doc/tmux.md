# Tmux Configuration

Terminal multiplexer based on [gpakosz/.tmux](https://github.com/gpakosz/.tmux) with Dracula theme.

## Structure

```
profile/
├── tmux.conf       # Base config (gpakosz/.tmux) → ~/.tmux.conf
└── tmux.local      # Local customizations → ~/.tmux.conf.local
```

## Prefix Key

**`Ctrl+B`** (also `Ctrl+A`)

## Keybindings

### Sessions
| Key | Action |
|-----|--------|
| `<prefix> d` | Detach |
| `<prefix> C-c` | New session |
| `<prefix> $` | Rename session |

### Windows
| Key | Action |
|-----|--------|
| `<prefix> c` | New window |
| `<prefix> ,` | Rename window |
| `<prefix> &` | Kill window |
| `<prefix> n/p` | Next/previous window |
| `Alt + ←/→` | Previous/next (no prefix) |

### Panes
| Key | Action |
|-----|--------|
| `<prefix> \|` | Split horizontal |
| `<prefix> -` | Split vertical |
| `<prefix> x` | Kill pane |
| `<prefix> z` | Zoom (fullscreen) |
| `<prefix> h/j/k/l` | Navigate (vim-style) |
| `Ctrl + h/j/k/l` | Navigate (vim-aware, no prefix) |

### Copy Mode
| Key | Action |
|-----|--------|
| `<prefix> [` | Enter copy mode |
| `v` | Begin selection |
| `y` | Copy |
| `<prefix> ]` | Paste |

### Other
| Key | Action |
|-----|--------|
| `<prefix> ?` | List keybindings |
| `<prefix> r` | Reload config |
| `<prefix> e` | Edit local config |
| `<prefix> m` | Toggle mouse |

## Status Bar

```
💀 session     windows...     🔌 85% 🦊 14:30 ♠ 25-Nov
```

Shows: session name, windows, prefix indicator, battery, time, date.

## Auto-start

ZSH automatically attaches to tmux session "main" on login.
Disabled in VS Code terminal.

## Customization

Edit `~/.dotfiles/profile/tmux.local` for theme and bindings.

## Commands

```bash
# Session management
tmux new -s name      # New session
tmux ls               # List sessions
tmux attach -t name   # Attach to session
tmux kill-session -t name

# Reload config
tmux source-file ~/.tmux.conf
```
