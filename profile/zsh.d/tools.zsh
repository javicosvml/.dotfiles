 # ZSH Tools Configuration

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

# Docker Engine: Set the default platform for Docker to linux/amd64
# Documentation: https://docs.docker.com/
export DOCKER_DEFAULT_PLATFORM="linux/amd64"
