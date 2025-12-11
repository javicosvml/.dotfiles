# Custom ZSH Prompt - Simple and informative
# Colors matched to Powerlevel10k configuration
# No external dependencies (no Pure, no Powerlevel10k)

# Enable prompt substitution
setopt PROMPT_SUBST

# ============================================================================
# PROMPT CONFIGURATION - Edit these variables to customize your prompt
# ============================================================================

# Color scheme (use ZSH color codes: 0-255 or named colors like 'red', 'blue')
# Reference: https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg
typeset -g PROMPT_COLOR_DIR=31              # Directory path (cyan)
typeset -g PROMPT_COLOR_GIT_BRANCH=76       # Git branch (bright green)
typeset -g PROMPT_COLOR_GIT_CLEAN=31        # Git brackets when clean (cyan)
typeset -g PROMPT_COLOR_GIT_STAGED=76       # Staged changes indicator (bright green)
typeset -g PROMPT_COLOR_GIT_UNSTAGED=178    # Unstaged changes indicator (yellow/orange)
typeset -g PROMPT_COLOR_GIT_UNTRACKED=160   # Untracked files indicator (red)
typeset -g PROMPT_COLOR_GIT_ACTION=160      # Git action (rebase, merge, etc.) (red)
typeset -g PROMPT_COLOR_SUCCESS=70          # Success indicator (green)
typeset -g PROMPT_COLOR_ERROR=160           # Error indicator (red)
typeset -g PROMPT_COLOR_ARROW=white         # Prompt arrow (white)
typeset -g PROMPT_COLOR_VIRTUALENV=37       # Python virtualenv (cyan light)
typeset -g PROMPT_COLOR_KUBECTL=134         # Kubectl context (magenta/pink)

# Symbols and characters
typeset -g PROMPT_SYMBOL_ARROW="❯"          # Main prompt arrow
typeset -g PROMPT_SYMBOL_SUCCESS="✓"        # Command succeeded
typeset -g PROMPT_SYMBOL_ERROR="✗"          # Command failed
typeset -g PROMPT_SYMBOL_GIT_STAGED="●"     # Staged changes
typeset -g PROMPT_SYMBOL_GIT_UNSTAGED="●"   # Unstaged changes
typeset -g PROMPT_SYMBOL_GIT_UNTRACKED="…"  # Untracked files
typeset -g PROMPT_SYMBOL_KUBECTL="☸"        # Kubernetes icon

# Prompt format options
typeset -g PROMPT_SHOW_GIT=true             # Show git status (true/false)
typeset -g PROMPT_SHOW_VIRTUALENV=true      # Show Python virtualenv (true/false)
typeset -g PROMPT_SHOW_KUBECTL=true         # Show kubectl context (true/false)

# ============================================================================
# END OF CONFIGURATION
# ============================================================================

# Git prompt using gitstatus (10x faster than vcs_info)
# Falls back to vcs_info if gitstatus is not available
function prompt_gitstatus() {
    [[ "$PROMPT_SHOW_GIT" != "true" ]] && return

    # Check if gitstatus is available
    if ! command -v gitstatus_query &>/dev/null; then
        return 1
    fi

    # Start gitstatus instance if not running
    gitstatus_stop 'MY' 2>/dev/null
    gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY' 2>/dev/null || return 1

    # Query gitstatus for git repo info
    gitstatus_query 'MY' 2>/dev/null || return 1  # Not in a git repo

    local branch="${VCS_STATUS_LOCAL_BRANCH:-@${VCS_STATUS_COMMIT}}"

    # Build status indicators using configured colors
    local indicators=""
    [[ -n $VCS_STATUS_ACTION ]] && indicators+="%F{$PROMPT_COLOR_GIT_ACTION}|$VCS_STATUS_ACTION%f"
    ((VCS_STATUS_HAS_STAGED))    && indicators+="%F{$PROMPT_COLOR_GIT_STAGED}${PROMPT_SYMBOL_GIT_STAGED}%f"
    ((VCS_STATUS_HAS_UNSTAGED))  && indicators+="%F{$PROMPT_COLOR_GIT_UNSTAGED}${PROMPT_SYMBOL_GIT_UNSTAGED}%f"
    ((VCS_STATUS_HAS_UNTRACKED)) && indicators+="%F{$PROMPT_COLOR_GIT_UNTRACKED}${PROMPT_SYMBOL_GIT_UNTRACKED}%f"

    echo " %F{$PROMPT_COLOR_GIT_CLEAN}(%f%F{$PROMPT_COLOR_GIT_BRANCH}${branch}%f${indicators}%F{$PROMPT_COLOR_GIT_CLEAN})%f"
}

# Fallback git prompt using vcs_info (slower but built-in)
function prompt_git_fallback() {
    [[ "$PROMPT_SHOW_GIT" != "true" ]] && return

    # Initialize vcs_info if not already done
    if ! command -v vcs_info &>/dev/null; then
        autoload -Uz vcs_info
        zstyle ':vcs_info:*' enable git
        zstyle ':vcs_info:git*' formats ' (%b)'
        zstyle ':vcs_info:git*' actionformats ' (%b|%a)'
    fi

    vcs_info
    if [[ -n "$vcs_info_msg_0_" ]]; then
        echo "%F{$PROMPT_COLOR_GIT_CLEAN}%f%F{$PROMPT_COLOR_GIT_BRANCH}$vcs_info_msg_0_%f"
    fi
}

# Hook to update git status before each prompt
precmd() {
    # vcs_info updates synchronously for the fallback
    if ! command -v gitstatus_query &>/dev/null; then
        vcs_info
    fi
}

# Function to display virtualenv/conda environment
prompt_virtualenv() {
    [[ "$PROMPT_SHOW_VIRTUALENV" != "true" ]] && return

    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "%F{${PROMPT_COLOR_VIRTUALENV:-37}}($(basename $VIRTUAL_ENV))%f " 2>/dev/null || echo "($(basename $VIRTUAL_ENV)) "
    elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "%F{${PROMPT_COLOR_VIRTUALENV:-37}}($CONDA_DEFAULT_ENV)%f " 2>/dev/null || echo "($CONDA_DEFAULT_ENV) "
    fi
}

# Function to display kubectl context with caching (macOS optimized)
# Cache invalidates when ~/.kube/config changes
typeset -g _kubectl_context_cache=""
typeset -g _kubectl_config_mtime=0

prompt_kubectl() {
    [[ "$PROMPT_SHOW_KUBECTL" != "true" ]] && return

    if ! command -v kubectl &>/dev/null; then
        return
    fi

    local kubeconfig="${KUBECONFIG:-$HOME/.kube/config}"
    if [[ ! -f "$kubeconfig" ]]; then
        return
    fi

    # macOS-specific file modification time check using stat -f
    local current_mtime
    current_mtime=$(stat -f %m "$kubeconfig" 2>/dev/null) || return

    if [[ "$current_mtime" != "$_kubectl_config_mtime" ]]; then
        # Update cache with error handling
        _kubectl_context_cache=$(kubectl config current-context 2>/dev/null) || _kubectl_context_cache=""
        _kubectl_config_mtime=$current_mtime
    fi

    if [[ -n "$_kubectl_context_cache" ]]; then
        echo "%F{${PROMPT_COLOR_KUBECTL:-134}}${PROMPT_SYMBOL_KUBECTL:-☸} %f%F{${PROMPT_COLOR_KUBECTL:-134}}$_kubectl_context_cache%f " 2>/dev/null || echo "${PROMPT_SYMBOL_KUBECTL:-☸} $_kubectl_context_cache "
    fi
}

# Function to show command status (success/error indicator only, no exit code)
prompt_exit_code() {
    echo "%(?.%F{${PROMPT_COLOR_SUCCESS:-70}}${PROMPT_SYMBOL_SUCCESS:-✓}%f.%F{${PROMPT_COLOR_ERROR:-160}}${PROMPT_SYMBOL_ERROR:-✗}%f)"
}

# Left prompt (main prompt) - Single line, no user@host
# Try gitstatus first, fall back to vcs_info if not available
_prompt_git_info() {
    if command -v gitstatus_query &>/dev/null; then
        prompt_gitstatus
    else
        prompt_git_fallback
    fi
}
PROMPT='%F{$PROMPT_COLOR_DIR}%~%f$(_prompt_git_info) $(prompt_exit_code) %F{$PROMPT_COLOR_ARROW}${PROMPT_SYMBOL_ARROW}%f '

# Right prompt (optional information)
RPROMPT='$(prompt_virtualenv)$(prompt_kubectl)'
