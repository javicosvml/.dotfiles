<div align="center">

# ZSH Configuration

Modern ZSH setup with Zinit plugin manager and Powerlevel10k theme

[Structure](#structure) •
[Features](#features) •
[Plugins](#plugins) •
[Aliases](#aliases) •
[Customization](#customization)

</div>

---

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

---

## Features

| Feature | Description |
|:--------|:------------|
| **Powerlevel10k** | Instant prompt with minimal latency |
| **Zinit** | Turbo-mode plugin loading for fast startup |
| **Auto-tmux** | Automatically attaches to session on login |
| **Modern CLI** | Modern alternatives: `bat`, `lsd`, `fd`, `ripgrep` |
| **FZF** | Fuzzy finder integration |

---

## Plugins

| Plugin | Description |
|:-------|:------------|
| [powerlevel10k](https://github.com/romkatv/powerlevel10k) | Fast, customizable prompt |
| [zsh-completions](https://github.com/zsh-users/zsh-completions) | Additional completion definitions |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Fish-like suggestions |
| [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) | Syntax highlighting |
| [history-search-multi-word](https://github.com/zdharma-continuum/history-search-multi-word) | Better history search |

---

## Aliases

### Modern CLI Replacements

| Alias | Tool | Description |
|:------|:-----|:------------|
| `cat` | [bat](https://github.com/sharkdp/bat) | Syntax highlighting |
| `ls`, `ll`, `lt` | [lsd](https://github.com/lsd-rs/lsd) / [eza](https://github.com/eza-community/eza) | Icons and colors |
| `find` | [fd](https://github.com/sharkdp/fd) | Faster, friendlier find |
| `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) | Ultra-fast search |

### Docker Quick Containers

```bash
kali     # Kali Linux container
debian   # Debian container
ubuntu   # Ubuntu container
alpine   # Alpine container
```

### macOS Utilities

| Alias | Description |
|:------|:------------|
| `showfiles` / `hidefiles` | Toggle hidden files in Finder |
| `flushdns` | Flush DNS cache |
| `afk` | Lock screen |
| `ql <file>` | Quick Look preview |

### Network

| Alias | Description |
|:------|:------------|
| `ip` | Show public IP address |
| `localip` | Show local IP address |
| `ports` | List listening ports |

---

## Customization

### Reconfigure Prompt

```bash
p10k configure
```

### Add Custom Aliases

Edit `~/.dotfiles/profile/zsh.d/alias.zsh`:

```bash
# Add your aliases
alias myalias='command here'
```

### Disable Auto-tmux

Comment out lines 4-8 in `~/.dotfiles/profile/zshrc`

---

## Troubleshooting

<details>
<summary><strong>Reload configuration</strong></summary>

```bash
source ~/.zshrc
```
</details>

<details>
<summary><strong>Rebuild completions</strong></summary>

```bash
rm ~/.zcompdump* && compinit
```
</details>

<details>
<summary><strong>Profile startup time</strong></summary>

```bash
time zsh -i -c exit
```
</details>

---

<div align="center">

[Back to README](../README.md)

</div>
