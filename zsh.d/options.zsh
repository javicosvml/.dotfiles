# Zsh Options (non-history related)

# Navigation options
setopt AUTO_CD                  # Change to directory without cd
setopt AUTO_PUSHD               # Push old directory onto stack
setopt PUSHD_IGNORE_DUPS        # Don't push duplicates
setopt PUSHD_MINUS              # Exchange meaning of +/-

# Completion behavior options
setopt ALWAYS_TO_END            # Move cursor to end after completion
setopt AUTO_LIST                # Automatically list choices on ambiguous completion
setopt AUTO_MENU                # Show completion menu on successive tab press
setopt COMPLETE_IN_WORD         # Allow completion from within a word
setopt LIST_PACKED              # Make completion list smaller
