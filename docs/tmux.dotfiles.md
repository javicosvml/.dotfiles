# Tmux Configuration

Single `tmux.conf` for tmux 3.4+, optimized for macOS with TokyoNight Night theme and native clipboard.

## Key Settings

| Setting | Value | Notes |
|---------|-------|-------|
| Prefix | `C-a` (GNU Screen style) | Primary prefix; default `C-b` still works |
| `default-terminal` | `tmux-256color` | RGB features enabled for kitty, xterm |
| `escape-time` | 10ms | Better macOS compatibility |
| `history-limit` | 50000 | |
| `mouse` | on | Scrolling, pane selection, resize |
| `base-index` | 1 | Windows start at 1 |
| `pane-base-index` | 1 | Panes start at 1 |
| `status-interval` | 10s | Status bar refresh |
| `renumber-windows` | on | Auto-renumber on close |

## Color Scheme (TokyoNight Night)

| Role | Hex |
|------|-----|
| Background | `#1a1b26` |
| Foreground / primary text | `#c0caf5` |
| Active border / accents | `#7aa2f7` |
| Active window / highlights | `#7dcfff` |
| Inactive / secondary text | `#565f89` |
| Success indicators | `#9ece6a` |

## Key Bindings

### Session & Windows

| Binding | Action |
|---------|--------|
| `prefix + C-c` | New session |
| `prefix + C-f` | Find/switch session |
| `prefix + BTab` | Last session |
| `prefix + -` | Split pane horizontal (current path) |
| `prefix + _` | Split pane vertical (current path) |
| `prefix + r` | Reload config |
| `prefix + e` | Edit config in new window |
| `prefix + Tab` | Last window |
| `prefix + C-h` / `C-l` | Previous / next window |

### Pane Navigation (Vim-style)

| Binding | Action |
|---------|--------|
| `C-h/j/k/l` | Navigate panes (tmux-aware, passes through to Neovim) |
| `prefix + h/j/k/l` | Navigate panes (explicit) |
| `prefix + H/J/K/L` | Resize panes |
| `prefix + >` / `<` | Swap pane forward/back |

### Copy Mode (vi keys)

| Binding | Action |
|---------|--------|
| `prefix + Enter` | Enter copy mode |
| `v` | Begin selection |
| `C-v` | Rectangle selection |
| `y` | Copy to `pbcopy` + exit |
| `H` / `L` | Start / end of line |
| Drag / double-click / triple-click | Copy to `pbcopy` |
| Right-click | Paste from `pbpaste` |

### Clipboard Design

No tmux-yank plugin. `y` pipes directly to `pbcopy`:

```tmux
bind -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy; tmux display 'Copied to clipboard'"
```

Mouse drag, double-click, and triple-click all also pipe to `pbcopy`. Right-click pastes via `pbpaste | tmux load-buffer`.

## Neovim Integration

`C-h/j/k/l` pane navigation is aware of Neovim splits via `vim-tmux-navigator`. The `is_vim` shell check uses macOS `ps -o state= -o comm=` format:

```bash
is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
```

## Plugins (TPM)

| Plugin | Purpose |
|--------|---------|
| `tmux-plugins/tmux-sensible` | Sane defaults |
| `tmux-plugins/tmux-resurrect` | Session save/restore |
| `tmux-plugins/tmux-continuum` | Auto-save every 15 min + restore on start |
| `christoomey/vim-tmux-navigator` | Seamless vim/tmux pane navigation |

Resurrect saves nvim sessions (`session` strategy) and pane contents. Continuum auto-restores on tmux start.

## Install / Reload

```bash
make tmux                        # symlink + install TPM
tmux source-file ~/.tmux.conf    # reload live config
# prefix + I                     # install TPM plugins
# prefix + U                     # update TPM plugins
```

## Troubleshoot Clipboard

```bash
tmux list-keys -T copy-mode-vi | grep "y send"   # verify y binding
tmux show -g mouse                               # verify mouse=on
bash scripts/validate-configs.sh                 # full validation
```
