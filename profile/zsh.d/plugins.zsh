# Zinit Plugins - Optimized with Turbo Mode

# Load Powerlevel10k theme FIRST (for instant prompt compatibility)
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Load Powerlevel10k configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Turbo-loaded plugins (deferred for faster startup)
# wait'0' = load immediately after prompt, but asynchronously

# Completions (load early, needed by other plugins)
zinit ice wait'0' lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# Autosuggestions
zinit ice wait'0' lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1

# Syntax highlighting (load last among completions)
zinit ice wait'0' lucid atinit'zicompinit; zicdreplay'
zinit light zdharma-continuum/fast-syntax-highlighting

# History search
zinit ice wait'0' lucid
zinit light zdharma-continuum/history-search-multi-word

# Kubernetes prompt (only if kubectl exists)
if [[ -x "$HOME/.asdf/shims/kubectl" ]] || command -v kubectl &>/dev/null; then
  zinit ice wait'1' lucid
  zinit light superbrothers/zsh-kubectl-prompt
fi
