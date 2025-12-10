# Kitty Terminal Integration

if [[ "$TERM" == "xterm-kitty" ]]; then
  # Kitty SSH integration
  alias ssh="kitty +kitten ssh"

  # Image viewing in terminal
  alias icat="kitty +kitten icat"

  # Diff with images support
  alias d="kitty +kitten diff"
fi
