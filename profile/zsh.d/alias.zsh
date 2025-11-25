# ZSH Aliases Configuration
# Optimized for macOS

# Docker/Podman container shortcuts
if command -v docker &>/dev/null || command -v podman &>/dev/null; then
  alias kali='docker run --rm -ti kalilinux/kali-last-release bash'
  alias debian='docker run --rm -ti debian:latest bash'
  alias ubuntu='docker run --rm -ti ubuntu:latest bash'
  alias alpine='docker run --rm -ti alpine:latest sh'
fi

# bat - Better cat with syntax highlighting
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  alias catt='bat'  # Full bat with paging
  alias batp='bat --style=plain'  # Plain without line numbers
fi

# Modern ls alternatives with fallback to standard ls
if command -v lsd &>/dev/null; then
  # lsd - Modern ls with icons
  alias ls='lsd'
  alias ll='lsd -lah'
  alias la='lsd -A'
  alias lt='lsd --tree'
  alias l='lsd -lh'
else
  # Fallback to standard ls with colors
  alias ls='ls --color=auto'
  alias ll='ls -lah --color=auto'
  alias la='ls -A --color=auto'
  alias lt='ls -lR --color=auto'  # Recursive, no tree without external tool
  alias l='ls -lh --color=auto'
fi

# Modern Unix tools replacements
if command -v fd &>/dev/null; then
  alias find='fd'
fi

if command -v rg &>/dev/null; then
  alias grep='rg'
fi

if command -v dust &>/dev/null; then
  alias du='dust'
fi

if command -v duf &>/dev/null; then
  alias df='duf'
fi

if command -v procs &>/dev/null; then
  alias ps='procs'
fi

# macOS specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Show/hide hidden files in Finder
  alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
  alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'

  # Flush DNS cache
  alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

  # Lock screen
  alias afk='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

  # Quick look file
  alias ql='qlmanage -p 2>/dev/null'

  # Open in default app
  alias o='open'
  alias o.='open .'
fi

# Safety aliases - prevent accidental overwrites
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Network utilities
alias ip='curl -s ifconfig.me'
alias localip='ipconfig getifaddr en0'
alias ports='lsof -i -P | grep LISTEN'

# Quick edits
alias zshrc='$EDITOR ~/.zshrc'
alias zshreload='source ~/.zshrc'
