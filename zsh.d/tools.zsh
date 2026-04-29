# ZSH Tools Configuration
# Optimized for macOS with Homebrew

# ASDF Version Manager (macOS optimized)
# Documentation: https://asdf-vm.com/
# Uses $HOMEBREW_PREFIX cached in env.zsh to avoid slow brew --prefix calls
_asdf_init() {
  local asdf_path=""

  # Check Homebrew installation first (macOS standard)
  if [[ -f "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" ]]; then
    asdf_path="$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"
  elif [[ -f "$HOME/.asdf/asdf.sh" ]]; then
    # Fallback to manual installation
    asdf_path="$HOME/.asdf/asdf.sh"
  fi

  if [[ -n "$asdf_path" ]]; then
    # shellcheck disable=SC1090
    source "$asdf_path" 2>/dev/null || return
    # Completions
    if [[ -d "$HOMEBREW_PREFIX/opt/asdf/share/zsh/site-functions" ]]; then
      # shellcheck disable=SC2206
      fpath=($HOMEBREW_PREFIX/opt/asdf/share/zsh/site-functions $fpath)
    elif [[ -d "${ASDF_DIR}/completions" ]]; then
      # shellcheck disable=SC2206,SC2128
      fpath=(${ASDF_DIR}/completions $fpath)
    fi
  fi
}
_asdf_init

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

# Neovim aliases (EDITOR/VISUAL set in env.zsh)
# Documentation: https://neovim.io/
if command -v nvim &>/dev/null; then
  alias vi="nvim"
  alias vim="nvim"
fi

# Docker Engine: Set the default platform
# Documentation: https://docs.docker.com/
if command -v docker &>/dev/null; then
  export DOCKER_DEFAULT_PLATFORM="linux/amd64"
fi

# fzf - Fuzzy finder configuration
# Documentation: https://github.com/junegunn/fzf
# Note: fzf scripts are lazy-loaded via Zinit in plugins.zsh
if command -v fzf &>/dev/null || [[ -f "$HOMEBREW_PREFIX/opt/fzf/bin/fzf" ]]; then
  # fzf appearance and behavior
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

# zoxide - Smarter cd command that learns your habits
# Documentation: https://github.com/ajeetdsouza/zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  # Optional: alias cd to z for seamless replacement
  # alias cd="z"
fi
