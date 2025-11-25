# ZSH Configuration

Modern ZSH setup with Zinit plugin manager and Powerlevel10k theme.

## Structure

```
profile/
├── zshrc              # Main entry point → ~/.zshrc
└── zsh.d/             # Modular configs → ~/.zsh.d/
    ├── env.zsh        # Environment variables, PATH
    ├── options.zsh    # ZSH options
    ├── history.zsh    # History settings
    ├── plugins.zsh    # Zinit plugins
    ├── completion.zsh # Autocompletion
    ├── colors.zsh     # Color configuration
    ├── kitty.zsh      # Kitty integration
    ├── alias.zsh      # Shell aliases
    └── tools.zsh      # Tool configs (ASDF, fzf, direnv)
```

## Features

- **Powerlevel10k** instant prompt
- **Zinit** turbo-mode plugin loading
- **Auto-tmux** on login (disabled in VS Code)
- **Modern CLI** aliases (bat, lsd, fd, ripgrep)
- **FZF** fuzzy finder integration

## Plugins

| Plugin | Description |
|--------|-------------|
| powerlevel10k | Fast, customizable prompt |
| zsh-completions | Additional completions |
| zsh-autosuggestions | Fish-like suggestions |
| fast-syntax-highlighting | Syntax highlighting |
| history-search-multi-word | Better history search |

## Aliases

### Modern CLI Replacements
| Alias | Tool | Description |
|-------|------|-------------|
| `cat` | bat | Syntax highlighting |
| `ls`, `ll`, `lt` | lsd/eza | Icons and colors |
| `find` | fd | Faster find |
| `grep` | rg | Ripgrep |

### Docker Quick Containers
```bash
kali     # Kali Linux
debian   # Debian
ubuntu   # Ubuntu
alpine   # Alpine
```

### macOS
| Alias | Description |
|-------|-------------|
| `showfiles` / `hidefiles` | Toggle hidden files in Finder |
| `flushdns` | Flush DNS cache |
| `afk` | Lock screen |
| `ql <file>` | Quick Look preview |

### Network
| Alias | Description |
|-------|-------------|
| `ip` | Public IP |
| `localip` | Local IP |
| `ports` | Listening ports |

## Customization

### Reconfigure Prompt
```bash
p10k configure
```

### Add Aliases
Edit `~/.dotfiles/profile/zsh.d/alias.zsh`

### Disable Auto-tmux
Comment out lines 4-8 in `~/.dotfiles/profile/zshrc`

## Troubleshooting

```bash
# Reload config
source ~/.zshrc

# Rebuild completions
rm ~/.zcompdump* && compinit

# Profile startup time
time zsh -i -c exit
```
