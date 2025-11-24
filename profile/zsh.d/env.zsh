# Environment Variables and Paths
# Loaded early in shell initialization

# Homebrew paths (macOS specific)
if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Add directories to PATH (ordered by priority)
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Man paths
export MANPATH="$MANPATH:/usr/local/man"

# Locale configuration (UTF-8 support)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Terminal configuration
export TERM="xterm-256color"
export COLORTERM="truecolor"

# Editor preferences
export EDITOR="nvim"
export VISUAL="nvim"
