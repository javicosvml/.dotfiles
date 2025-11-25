# Kitty Configuration

GPU-accelerated terminal emulator with modular configuration.

## Structure

```
config/kitty/
├── kitty.conf           # Main config → ~/.config/kitty/
├── conf.d/
│   ├── fonts.conf       # Font settings
│   ├── macos.conf       # macOS-specific
│   └── keybindings.conf # Shortcuts
└── themes/
    ├── tokyonight.conf
    ├── dracula.conf
    ├── nord.conf
    └── material-dark.conf
```

## Keybindings

Modifier: **`Cmd`** (⌘)

### Clipboard
| Key | Action |
|-----|--------|
| `Cmd+C` | Copy |
| `Cmd+V` | Paste |

### Tabs
| Key | Action |
|-----|--------|
| `Cmd+T` | New tab |
| `Cmd+Shift+W` | Close tab |
| `Cmd+Shift+←/→` | Previous/next tab |
| `Cmd+1-9` | Go to tab |

### Windows
| Key | Action |
|-----|--------|
| `Cmd+N` | New OS window |
| `Cmd+Enter` | New split |
| `Cmd+W` | Close window |
| `Cmd+]/[` | Next/previous window |

### Font
| Key | Action |
|-----|--------|
| `Cmd+=` | Increase size |
| `Cmd+-` | Decrease size |
| `Cmd+0` | Reset size |

### Other
| Key | Action |
|-----|--------|
| `Cmd+K` | Clear scrollback |
| `Cmd+,` | Edit config |
| `Cmd+Shift+,` | Reload config |
| `Cmd+F` | Search scrollback (fzf) |

## Theme

Current: `tokyonight.conf`

Change in `kitty.conf`:
```conf
include themes/dracula.conf
```

## Font

Current: JetBrains Mono Nerd Font

Edit `conf.d/fonts.conf` to change.

## Customization

```bash
# List available fonts
kitty +list-fonts

# Test config
kitty --debug-config
```

## Troubleshooting

```bash
# Reload config
Cmd+Shift+,

# Check TERM
echo $TERM  # Should be: xterm-kitty
```
