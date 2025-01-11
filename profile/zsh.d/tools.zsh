# ASDF Version Manager Setup
# Documentation: https://asdf-vm.com/
if [[ -d "$HOME/.asdf" ]]; then
  source "$HOME/.asdf/asdf.sh"
  # Force x86_64 architecture for asdf on non-x86_64 systems (Mac M1, etc.)
  if [[ "$(uname -m)" != "x86_64" ]]; then
    alias asdf='arch -x86_64 asdf'
  fi
fi

# TMUX: Start a new tmux session if not already inside one
# Documentation: https://github.com/tmux/tmux
if [[ -z "$TMUX" ]]; then
  tmux
fi

# EDITOR Setup: Let’s use Neovim if available
# Documentation: https://neovim.io/
if command -v nvim &>/dev/null; then
  export VISUAL="nvim"
  export EDITOR="$VISUAL"
  alias vi="nvim"
fi

# GOLANG: Add Go binary path to $PATH if GOPATH is set
# Documentation: https://golang.org/
if [[ -d "$GOPATH" ]]; then
  export PATH="$PATH:$GOPATH/bin"
fi

# Docker Engine: Set the default platform for Docker to linux/amd64
# Documentation: https://docs.docker.com/
export DOCKER_DEFAULT_PLATFORM="linux/amd64"