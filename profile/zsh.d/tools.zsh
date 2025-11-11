# ZSH Tools Configuration
# Optimized for macOS with Homebrew

# ASDF Version Manager (Homebrew installation)
# Documentation: https://asdf-vm.com/
# IMPORTANT: ASDF is sourced AFTER Homebrew to ensure ASDF-managed tools take priority in PATH
if [[ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]]; then
  source "$(brew --prefix asdf)/libexec/asdf.sh"
  # Prepend ASDF shims to PATH to prioritize ASDF-managed tools over Homebrew
  export PATH="$HOME/.asdf/shims:$PATH"
  # Append completions to fpath
  fpath=($(brew --prefix asdf)/share/zsh/site-functions $fpath)
elif [[ -f "$HOME/.asdf/asdf.sh" ]]; then
  # Fallback to manual installation
  source "$HOME/.asdf/asdf.sh"
  export PATH="$HOME/.asdf/shims:$PATH"
  fpath=(${ASDF_DIR}/completions $fpath)
fi

# TMUX: Start a new tmux session if not already inside one
# Documentation: https://github.com/tmux/tmux
# Only auto-start on interactive shells, not in VS Code, Kitty tabs, or other terminals
# Disabled to prevent instant prompt warnings - uncomment if needed
# if [[ -z "$TMUX" ]] && [[ -z "$VSCODE_INJECTION" ]] && [[ -z "$TERM_PROGRAM" ]] && [[ "$TERM" != "xterm-kitty" ]]; then
#   if command -v tmux &>/dev/null; then
#     # Check if there's a session named 'main', attach or create
#     tmux has-session -t main 2>/dev/null && tmux attach-session -t main || tmux new-session -s main
#   fi
# fi

# EDITOR Setup: Neovim as default editor
# Documentation: https://neovim.io/
if command -v nvim &>/dev/null; then
  export VISUAL="nvim"
  export EDITOR="$VISUAL"
  alias vi="nvim"
  alias vim="nvim"
fi

# Docker Engine: Set the default platform
# Documentation: https://docs.docker.com/
if command -v docker &>/dev/null; then
  export DOCKER_DEFAULT_PLATFORM="linux/amd64"
fi

# fzf - Fuzzy finder (if installed via Homebrew)
# Documentation: https://github.com/junegunn/fzf
if [[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]]; then
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
  source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
  
  # fzf configuration
  export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
    --inline-info
    --color=fg:#d0d0d0,bg:#121212,hl:#5f87af
    --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
    --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
    --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
  '
  
  # Use fd instead of find if available
  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# bat - Better cat (if installed)
# Documentation: https://github.com/sharkdp/bat
if command -v bat &>/dev/null; then
  export BAT_THEME="TwoDark"
  export BAT_STYLE="numbers,changes,header"
fi
