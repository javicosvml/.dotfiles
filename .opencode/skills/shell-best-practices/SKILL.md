---
name: shell-best-practices
description: Shell scripting patterns and best practices for this dotfiles project
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: development
  tags: shell,zsh,scripting,bash
---

# Shell Best Practices Skill

Shell scripting patterns and conventions used in this dotfiles project.

## ZSH-Specific Patterns

### Safe Script Header

```bash
#!/usr/bin/env zsh
# vim: set ft=zsh:

set -euo pipefail  # Exit on error, undefined vars, pipe failures
emulate -L zsh     # Local emulation for safety

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
```

### Conditional Color Output

```bash
# Print colored status
print_status() {
  local status=$1
  local message=$2
  case $status in
    error)
      echo -e "${RED}✗ ERROR${NC}: $message"
      ;;
    success)
      echo -e "${GREEN}✓ OK${NC}: $message"
      ;;
    warn)
      echo -e "${YELLOW}⚠ WARN${NC}: $message"
      ;;
  esac
}
```

### Safe File Operations

```bash
# Check file exists
if [[ -f "$filename" ]]; then
  echo "File exists"
fi

# Check directory exists
if [[ -d "$dirname" ]]; then
  echo "Directory exists"
fi

# Check if symlink
if [[ -L "$path" ]]; then
  echo "Is symlink"
fi

# Safe backup
if [[ -f "$file" && ! -L "$file" ]]; then
  mv "$file" "$file.backup"
fi
```

### Loop Patterns

```bash
# Loop over array
for item in "${array[@]}"; do
  echo "$item"
done

# Loop over files
for file in *.zsh; do
  echo "Processing $file"
done

# Loop with counter
for ((i=0; i<${#array[@]}; i++)); do
  echo "$i: ${array[$i]}"
done
```

### Function Patterns

```bash
# Simple function
my_function() {
  local var1=$1
  local var2=$2

  # Function body
  echo "var1=$var1, var2=$var2"

  return 0  # Explicit return
}

# Function with error handling
safe_function() {
  set -euo pipefail

  if ! command -v some_cmd &>/dev/null; then
    echo "Error: some_cmd not found" >&2
    return 1
  fi

  some_cmd "$@"
}
```

## Git in Shell Scripts

### Safe Git Operations

```bash
# Check if in git repo
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Not in git repository"
  exit 1
fi

# Check current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Check for uncommitted changes
if ! git diff-files --quiet; then
  echo "Uncommitted changes exist"
fi

# Safe commit
git add .
git commit -m "message" || true  # Don't fail if nothing to commit
```

## Make Integration

### Calling Make Targets

```bash
# Simple target
make verify

# Target with output capture
if make profile >/dev/null 2>&1; then
  echo "Profile installed"
else
  echo "Profile installation failed"
  exit 1
fi
```

## Input/Output Patterns

### Reading User Input

```bash
# Simple yes/no
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Continuing..."
fi

# Read with validation
read -p "Enter value: " value
if [[ -z "$value" ]]; then
  echo "Error: value required"
  exit 1
fi
```

### Error Messages

```bash
# Always use stderr for errors
echo "Error message" >&2
echo "Warning: something" >&2

# Success to stdout
echo "Success: operation completed"
```

## Command Substitution

### Safe Command Substitution

```bash
# Capture output
output=$(command 2>&1)  # Include stderr
status=$?  # Capture exit code

# Check result
if [[ $status -eq 0 ]]; then
  echo "Command succeeded: $output"
else
  echo "Command failed with code $status"
fi
```

## Path Manipulation

### Safe PATH Handling

```bash
# Append to PATH
export PATH="/new/path:$PATH"

# Check if in PATH
if ! echo "$PATH" | grep -q "/expected/path"; then
  echo "Warning: /expected/path not in PATH"
fi

# Get directory of script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
```

## Validation Patterns

### Pre-validation Checklist

```bash
# Check prerequisites
errors=0

if ! command -v git &>/dev/null; then
  echo "Error: git required"
  ((errors++))
fi

if ! command -v zsh &>/dev/null; then
  echo "Error: zsh required"
  ((errors++))
fi

if [[ $errors -gt 0 ]]; then
  echo "Fix $errors error(s) above"
  exit 1
fi
```

### Syntax Validation

```bash
# Check ZSH syntax
for file in zsh.d/*.zsh; do
  if ! zsh -n "$file" 2>/dev/null; then
    echo "Syntax error in $file"
    zsh -n "$file"  # Show full error
    exit 1
  fi
done

# Check Tmux syntax
if ! tmux source-file -v tmux.conf &>/dev/null; then
  echo "Syntax error in tmux.conf"
  exit 1
fi
```

## Logging Patterns

### Consistent Output

```bash
# Logging function
log() {
  local level=$1
  shift
  local message="$@"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message"
}

log "INFO" "Starting process"
log "WARN" "Something unusual"
log "ERROR" "Failed to do X"
```

## Anti-Patterns to Avoid

| Pattern | Why Bad | Alternative |
|---|---|---|
| `eval $var` | Security risk, quote issues | Use arrays or functions |
| `command $1` | Unsafe variable expansion | Quote: `"$1"` |
| `grep "pattern"` | May fail silently | Add error handling |
| `cd path && cmd` | If cd fails, cmd runs in wrong dir | Use subshell or check cd |
| `if [ $? -eq 0 ]` | Brittle | Use `if command; then` |
| `rm -rf $dir` | Dangerous with unset vars | Always quote: `"$dir"` |

## Related Files

- `scripts/validate-configs.sh` (validation patterns)
- `.pre-commit-config.yaml` (ShellCheck rules)
- `Makefile` (GNU Make patterns)
- `docs/zsh.dotfiles.md` (ZSH reference)
