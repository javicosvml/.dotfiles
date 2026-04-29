# Kitty Terminal Configuration

GPU-accelerated terminal with TokyoNight Night theme, glassmorphism transparency, and macOS-native integration.

## Core Settings

| Setting | Value |
|---------|-------|
| Font | JetBrains Mono 10pt (all variants) |
| Cell height | 120% (increased line spacing) |
| Background opacity | 0.93 (frosted glass) |
| Background blur | 50 (macOS frosted glass effect) |
| Inactive window dim | 0.75 |
| Inactive text alpha | 0.80 |
| Scrollback | 10,000 lines |
| Initial size | 1200×700 |
| Window padding | 12px |
| Cursor | Block, blinking at 550ms |

## Color Scheme (TokyoNight Night)

| Role | Hex |
|------|-----|
| Foreground | `#c0caf5` |
| Background | `#1a1b26` |
| Selection bg | `#33467c` |
| Active border | `#7aa2f7` |
| Active tab bg | `#7aa2f7` |
| Inactive tab bg | `#292e42` |
| Tab bar bg | `#15161e` |
| URL color | `#73daca` |

Normal palette: `color0-7` = TokyoNight standard. Extended: `color16=#ff9e64`, `color17=#db4b4b`.

## Keyboard Shortcuts

`kitty_mod` is mapped to `cmd`.

### Window & Tab Management

| Shortcut | Action |
|----------|--------|
| `cmd+n` | New OS window |
| `cmd+w` | Close window/split |
| `cmd+enter` | New split |
| `cmd+]` / `cmd+[` | Next / prev split |
| `cmd+t` | New tab |
| `cmd+shift+w` | Close tab |
| `cmd+shift+right/left` | Next / prev tab |
| `cmd+1-9` | Go to tab N |
| `cmd+l` | Next layout |

### Transparency Toggle (live)

| Shortcut | Action |
|----------|--------|
| `cmd+shift+a` | Increase opacity +0.1 |
| `cmd+shift+s` | Decrease opacity -0.1 |
| `cmd+shift+d` | Reset to default opacity |

### Scrolling

| Shortcut | Action |
|----------|--------|
| `cmd+k` | Clear scrollback |
| `cmd+shift+k` | Reset terminal |
| `cmd+up/down` | Scroll line |
| `cmd+page_up/down` | Scroll page |
| `cmd+home/end` | Scroll to top/bottom |

### Search

```
cmd+f — launches fzf over screen scrollback in an overlay
```

## macOS Integration

- `hide_window_decorations titlebar-only` — clean titlebar, keeps traffic lights
- `macos_titlebar_color background` — seamless title bar
- `macos_colorspace displayp3` — wide color gamut on modern Macs
- `macos_thicken_font 0.1` — slightly bolder for Retina readability
- `allow_remote_control yes` + `listen_on unix:/tmp/kitty` — enables CLI control
- `shell_integration no-cursor` — uses own cursor, not shell integration cursor
- `copy_on_select yes` — primary selection → clipboard on mouse drag

## Editor

`editor nvim` — Kitty opens `nvim` for `cmd+,` (edit config).

## Reload Config

```bash
# Keyboard
cmd+shift+,   # reload kitty.conf live

# Terminal
kill -SIGUSR1 $(pgrep kitty)
```

## Adjusting Transparency

```conf
# More see-through
background_opacity 0.88
background_blur 40

# More frosted
background_opacity 0.95
background_blur 70
```

## Tab Bar

Style: `fade` (smooth gradient transitions between active/inactive tabs). Positioned at top. Shows bell/activity indicators + index and title. Tabs hidden when only 1 tab open (`tab_bar_min_tabs 2`).
