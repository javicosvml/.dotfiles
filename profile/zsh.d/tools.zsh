# Tool paths

# ASDF
if [[ -d $HOME/.asdf ]]; then
  source $HOME/.asdf/asdf.sh
  if [[ $(uname -m) != "x86_64" ]]; then
    alias asdf='arch -x86_64 asdf'
  fi
fi

# TMUX
if [[ "$TMUX" = "" ]]; then tmux; fi

# EDITOR
if [[ -f $(which nvim) ]]; then
  export VISUAL='vi'
  export EDITOR="$VISUAL"
  alias vi='nvim'
fi

# GOLANG
if [ -d "$GOPATH" ]; then
  export PATH="$PATH:$GOPATH/bin"
fi

# DOCKER ENGINE ARCH
export DOCKER_DEFAULT_PLATFORM="linux/amd64"
