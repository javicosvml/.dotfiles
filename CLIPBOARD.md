# Clipboard Configuration Guide

Complete clipboard integration for tmux and zsh on macOS.

## Overview

This dotfiles configuration provides seamless clipboard integration between:
- **Direct shell commands**: `pbcopy` / `pbpaste`
- **Tmux copy-mode**: Vi-style selection and copy
- **Mouse interactions**: Drag, double-click, triple-click
- **ZSH integration**: Full environment support

## System Requirements

- macOS (native `pbcopy` and `pbpaste` commands)
- Tmux 3.0+
- ZSH 5.0+

## Features

### 1. ZSH Clipboard Support

ZSH can use pbcopy/pbpaste directly:

```bash
# Copy to clipboard
echo "Hello World" | pbcopy

# Paste from clipboard
pbpaste

# Pipe between commands
cat file.txt | pbcopy
```

### 2. Tmux Copy Mode

#### Vi-Style Copy Mode

**Enter copy mode:**
```
Ctrl+b [
```

**Navigation in copy mode:**
- `h`, `j`, `k`, `l` - Move cursor (vim keys)
- `0` - Start of line
- `$` - End of line
- `Home`, `End` - Line boundaries
- `Ctrl+b`, `Ctrl+f` - Page up/down

**Selection:**
- `Space` - Begin selection
- `v` - Toggle between character and line selection
- `Ctrl+v` - Rectangle selection mode

**Copy to clipboard:**
- `y` - Copy selection to clipboard and exit copy mode
- `Enter` - Alternative: copy selection to clipboard

**Paste from clipboard:**
- `Ctrl+b ]` - Paste from tmux buffer
- Mouse right-click - Paste from system clipboard

#### Mouse Interactions

**In normal mode (outside copy-mode):**
- Left-click and drag → Select and copy to clipboard
- Double-click → Select word and copy
- Triple-click → Select line and copy
- Right-click (button 3) → Paste from system clipboard

**In copy-mode:**
- Left-click and drag → Select text
- Release → Automatically copies to clipboard
- Double-click → Select word and copy
- Triple-click → Select line and copy

### 3. Usage Examples

#### Copy from tmux to clipboard

```bash
# In tmux terminal:
# 1. Press Ctrl+b then [ to enter copy mode
# 2. Move to text you want to copy
# 3. Press Space to start selection
# 4. Move to end of desired text
# 5. Press 'y' to copy
# 6. Paste elsewhere with Cmd+V
```

#### Paste from clipboard into tmux

```bash
# Method 1: Using right-click
# Right-click in tmux pane → pastes from system clipboard

# Method 2: Using tmux command
# Ctrl+b then ]
# This pastes the tmux buffer (may not be clipboard content)

# Method 3: Via shell
pbpaste | command
```

#### Copy entire pane

```bash
# In tmux (outside copy-mode):
# Ctrl+b then [  (enter copy mode)
# Ctrl+a          (select all - NOT standard tmux, use instead:)
# 0 then G        (select from start to end)
# y               (copy)
```

#### Quick copy of last line

```bash
# In tmux normal mode:
# Ctrl+b then y   (copy line from display)
```

## Keyboard Shortcuts Reference

| Action | Command |
|--------|---------|
| Enter copy mode | `Ctrl+b [` |
| Exit copy mode | `Escape` or `q` |
| Copy to clipboard | `y` (in copy-mode) |
| Paste from buffer | `Ctrl+b ]` |
| Paste from clipboard | Right-click |
| Select all | `0` + `G` (in copy-mode) |
| Scroll up | `Ctrl+b PgUp` or `Scroll wheel` |
| Scroll down | `Ctrl+b PgDn` or `Scroll wheel` |

## Troubleshooting

### Clipboard not working in copy-mode

1. **Verify pbcopy is available:**
   ```bash
   command -v pbcopy
   ```

2. **Check tmux configuration:**
   ```bash
   tmux source-file -v ~/.tmux.conf 2>&1 | grep -i copy
   ```

3. **Verify binding:**
   ```bash
   tmux list-keys -T copy-mode-vi | grep -i "y send"
   ```

4. **Reload configuration:**
   ```bash
   tmux source-file ~/.tmux.conf
   ```

### Mouse not working

1. **Verify mouse support:**
   ```bash
   tmux show -g mouse
   ```
   Should output: `mouse on`

2. **Check terminal support:**
   - Ensure running inside tmux session
   - Mouse support may vary by terminal app

3. **Disable and re-enable:**
   ```bash
   tmux set -g mouse off
   tmux set -g mouse on
   ```

### Paste not working from system clipboard

1. **Manual paste:** Press `Cmd+V` when cursor is in tmux pane
2. **Via command:** `pbpaste | command`
3. **Check right-click binding:**
   ```bash
   tmux list-keys | grep MouseDown3Pane
   ```

## Configuration Files

- **Main tmux config:** `~/.tmux.conf` (symlinked to `~/.dotfiles/tmux.conf`)
- **ZSH config:** `~/.zshrc` (symlinked to `~/.dotfiles/zshrc`)
- **ZSH modules:** `~/.zsh.d/` (symlinked to `~/.dotfiles/zsh.d/`)

## Validation

Run configuration validation:

```bash
bash scripts/validate-configs.sh
```

This checks:
- Tmux syntax and bindings
- ZSH syntax and modules
- pbcopy/pbpaste availability
- Copy mode bindings configuration

## Performance Notes

- Vi-mode copy operations are instant (~1ms)
- Mouse drag operations are instant in most terminals
- Clipboard operations use native macOS APIs (very fast)
- No external dependencies beyond tmux and zsh

## Platform Support

- ✅ macOS (all versions with pbcopy/pbpaste)
- ✅ Works with Kitty terminal
- ✅ Works with native Terminal.app
- ✅ Works with iTerm2
- ⚠️ Other platforms would need `xclip` or `wl-copy` equivalent

## Additional Resources

- [Tmux Documentation](https://github.com/tmux/tmux/wiki)
- [Tmux Copy Mode](https://github.com/tmux/tmux/wiki/Getting-Started#copy--paste)
- [ZSH Manual](http://zsh.sourceforge.net/Doc/Release/)
- [pbcopy Reference](https://ss64.com/osx/pbcopy.html)
