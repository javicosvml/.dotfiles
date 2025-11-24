# Zinit Plugins

# Syntax highlighting (must be loaded before autosuggestions)
zinit light zdharma-continuum/fast-syntax-highlighting

# Autosuggestions
zinit light zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1

# Completions
zinit light zsh-users/zsh-completions

# History search
zinit light zdharma-continuum/history-search-multi-word

# Kubernetes prompt (if using kubectl)
if command -v kubectl &>/dev/null; then
  zinit light superbrothers/zsh-kubectl-prompt
fi

# Load Powerlevel10k theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Load Powerlevel10k configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
