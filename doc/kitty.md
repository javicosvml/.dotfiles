<div align="center">

# Kitty Configuration

GPU-accelerated terminal emulator with modular configuration

[Structure](#structure) •
[Keybindings](#keybindings) •
[Theme](#theme) •
[Customization](#customization)

</div>

---

## Structure

```
config/kitty/
├── kitty.conf           # Main config → ~/.config/kitty/
├── conf.d/
│   ├── fonts.conf       # Font settings
│   ├── macos.conf       # macOS-specific options
│   └── keybindings.conf # Keyboard shortcuts
└── themes/
    ├── tokyonight.conf
    ├── dracula.conf
    ├── nord.conf
    └── material-dark.conf
```

---

## Keybindings

**Modifier:** `Cmd` (⌘)

### Clipboard

| Key | Action |
|:----|:-------|
| `⌘ C` | Copy |
| `⌘ V` | Paste |

### Tabs

| Key | Action |
|:----|:-------|
| `⌘ T` | New tab |
| `⌘ ⇧ W` | Close tab |
| `⌘ ⇧ ←/→` | Previous/Next tab |
| `⌘ 1-9` | Go to tab N |

### Windows

| Key | Action |
|:----|:-------|
| `⌘ N` | New OS window |
| `⌘ ↵` | New split window |
| `⌘ W` | Close window |
| `⌘ ]` / `⌘ [` | Next/Previous window |

### Font Size

| Key | Action |
|:----|:-------|
| `⌘ =` | Increase font size |
| `⌘ -` | Decrease font size |
| `⌘ 0` | Reset font size |

### Miscellaneous

| Key | Action |
|:----|:-------|
| `⌘ K` | Clear scrollback |
| `⌘ ,` | Edit configuration |
| `⌘ ⇧ ,` | Reload configuration |
| `⌘ F` | Search scrollback (fzf) |

---

## Theme

**Current:** `tokyonight.conf`

### Available Themes

| Theme | File |
|:------|:-----|
| Tokyo Night | `themes/tokyonight.conf` |
| Dracula | `themes/dracula.conf` |
| Nord | `themes/nord.conf` |
| Material Dark | `themes/material-dark.conf` |

### Change Theme

Edit `kitty.conf`:

```conf
include themes/dracula.conf
```

---

## Font

**Current:** JetBrains Mono Nerd Font

Edit `conf.d/fonts.conf` to change font settings.

---

## Customization

### List Available Fonts

```bash
kitty +list-fonts
```

### Test Configuration

```bash
kitty --debug-config
```

---

## Troubleshooting

<details>
<summary><strong>Reload configuration</strong></summary>

Press `⌘ ⇧ ,` or:

```bash
kill -SIGUSR1 $(pgrep kitty)
```
</details>

<details>
<summary><strong>Check TERM variable</strong></summary>

```bash
echo $TERM
# Should output: xterm-kitty
```
</details>

---

<div align="center">

[Back to README](../README.md)

</div>
