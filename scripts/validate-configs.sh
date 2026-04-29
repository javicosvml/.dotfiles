#!/usr/bin/env bash
# Configuration validation script for tmux and zsh
# Validates syntax and configuration integrity
# Used by pre-commit hook

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Function to print colored output
print_status() {
  local status=$1
  local message=$2
  case $status in
    error)
      echo -e "${RED}✗ ERROR${NC}: $message"
      (( ERRORS += 1 ))
      ;;
    warn)
      echo -e "${YELLOW}⚠ WARN${NC}: $message"
      (( WARNINGS += 1 ))
      ;;
    ok)
      echo -e "${GREEN}✓ OK${NC}: $message"
      ;;
  esac
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Configuration Validation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ============================================================================
# TMUX CONFIGURATION VALIDATION
# ============================================================================
echo -e "\n${YELLOW}[TMUX Configuration]${NC}"

TMUX_CONFIG="$DOTFILES_DIR/tmux.conf"
if [[ ! -f "$TMUX_CONFIG" ]]; then
  print_status error "tmux.conf not found at $TMUX_CONFIG"
else
  # Check tmux syntax
  if command -v tmux &>/dev/null; then
    if tmux source-file -v "$TMUX_CONFIG" &>/dev/null; then
      print_status ok "tmux configuration syntax is valid"
    else
      print_status error "tmux configuration has syntax errors"
      tmux source-file -v "$TMUX_CONFIG" 2>&1 | head -10
    fi
  else
    print_status warn "tmux not installed, skipping syntax check"
  fi

  # Check for critical bindings
  if grep -q "copy-pipe-and-cancel.*pbcopy" "$TMUX_CONFIG"; then
    print_status ok "Copy to clipboard binding found"
  else
    print_status error "Missing pbcopy binding in copy-mode-vi"
  fi

  if grep -q "bind -T copy-mode-vi y" "$TMUX_CONFIG"; then
    print_status ok "Vi-style 'y' copy binding found"
  else
    print_status error "Missing Vi-style 'y' copy binding"
  fi

  if grep -q "pbpaste" "$TMUX_CONFIG"; then
    print_status ok "Paste from clipboard binding found"
  else
    print_status error "Missing pbpaste binding"
  fi

  # Check for plugin conflicts
  if grep -q "tmux-yank" "$TMUX_CONFIG" && ! grep -q "^# REMOVED.*tmux-yank" "$TMUX_CONFIG"; then
    print_status warn "tmux-yank plugin may conflict with native pbcopy bindings"
  else
    print_status ok "No tmux-yank plugin conflict detected"
  fi

  # Check for mouse support
  if grep -q "set -g mouse on" "$TMUX_CONFIG"; then
    print_status ok "Mouse support enabled"
  else
    print_status warn "Mouse support not enabled"
  fi

  # Check for copy mode key bindings
  if grep -q "bind -T copy-mode-vi MouseDragEnd1Pane" "$TMUX_CONFIG"; then
    print_status ok "Mouse drag-end copy binding found"
  else
    print_status error "Missing mouse drag-end binding"
  fi

fi

# ============================================================================
# ZSH CONFIGURATION VALIDATION
# ============================================================================
echo -e "\n${YELLOW}[ZSH Configuration]${NC}"

ZSH_CONFIG="$DOTFILES_DIR/zshrc"
if [[ ! -f "$ZSH_CONFIG" ]]; then
  print_status error "zshrc not found at $ZSH_CONFIG"
else
  # Check zshrc syntax
  if command -v zsh &>/dev/null; then
    if zsh -n "$ZSH_CONFIG" 2>/dev/null; then
      print_status ok "zshrc syntax is valid"
    else
      print_status error "zshrc has syntax errors"
      zsh -n "$ZSH_CONFIG" 2>&1 | head -10
    fi
  else
    print_status warn "zsh not installed, skipping syntax check"
  fi

  # Check for required sources (supports both zsh.d and $ZSH_CONFIG_DIR)
  if grep -q 'source.*\.d/' "$ZSH_CONFIG" || grep -q 'source.*ZSH_CONFIG_DIR' "$ZSH_CONFIG"; then
    print_status ok "zsh.d modular sources found"
  else
    print_status error "Missing zsh.d module sources"
  fi

fi

# ============================================================================
# ZSH MODULES VALIDATION
# ============================================================================
echo -e "\n${YELLOW}[ZSH Modules]${NC}"

ZSH_D_DIR="$DOTFILES_DIR/zsh.d"
if [[ ! -d "$ZSH_D_DIR" ]]; then
  print_status error "zsh.d directory not found"
else
  REQUIRED_MODULES=(
    "env.zsh"
    "options.zsh"
    "history.zsh"
    "plugins.zsh"
    "prompt.zsh"
    "completion.zsh"
    "colors.zsh"
    "kitty.zsh"
    "alias.zsh"
    "tools.zsh"
  )

  for module in "${REQUIRED_MODULES[@]}"; do
    MODULE_PATH="$ZSH_D_DIR/$module"
    if [[ ! -f "$MODULE_PATH" ]]; then
      print_status error "Missing required module: $module"
    else
      # Basic syntax check
      if command -v zsh &>/dev/null; then
        if zsh -n "$MODULE_PATH" 2>/dev/null; then
          print_status ok "$module syntax valid"
        else
          print_status error "$module has syntax errors"
        fi
      fi
    fi
  done
fi

# ============================================================================
# CLIPBOARD FUNCTIONALITY TESTS
# ============================================================================
echo -e "\n${YELLOW}[Clipboard Functionality]${NC}"

# Test pbcopy/pbpaste
if command -v pbcopy &>/dev/null && command -v pbpaste &>/dev/null; then
  TEST_TEXT="clipboard_test_$(date +%s)"
  if echo "$TEST_TEXT" | pbcopy && pbpaste | grep -q "$TEST_TEXT"; then
    print_status ok "pbcopy/pbpaste working correctly"
  else
    print_status error "pbcopy/pbpaste test failed"
  fi
else
  print_status error "pbcopy/pbpaste commands not found"
fi

# Test tmux clipboard integration if tmux is running
if command -v tmux &>/dev/null; then
  # Check if we can create a test session
  if tmux new-session -d -s config_test_$$ 2>/dev/null; then
    # Test save-buffer
    tmux send-keys -t config_test_$$ "echo 'tmux_clipboard_test'" Enter
    sleep 0.5
    if tmux save-buffer - 2>/dev/null | grep -q tmux_clipboard; then
      print_status ok "tmux buffer operations working"
    else
      print_status warn "tmux buffer test inconclusive"
    fi
    tmux kill-session -t config_test_$$ 2>/dev/null || true
  fi
fi

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
echo -e "\n${YELLOW}[Environment Variables]${NC}"

ZSH_ENV="$ZSH_D_DIR/env.zsh"
if grep -q "export HOMEBREW_PREFIX" "$ZSH_ENV"; then
  print_status ok "Homebrew path caching configured"
else
  print_status error "Missing HOMEBREW_PREFIX export"
fi

if grep -q "export EDITOR=" "$ZSH_ENV" || grep -q "export EDITOR=" "$DOTFILES_DIR/zsh.d"/*.zsh; then
  print_status ok "EDITOR environment variable configured"
else
  print_status error "EDITOR environment variable not configured"
fi

# ============================================================================
# SUMMARY
# ============================================================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Validation Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Errors:   ${RED}$ERRORS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"

if [[ $ERRORS -eq 0 ]]; then
  echo -e "${GREEN}✓ All validations passed!${NC}"
  if [[ $WARNINGS -gt 0 ]]; then
    echo -e "${YELLOW}⚠ ($WARNINGS warning(s) - not blocking)${NC}"
  fi
  exit 0
else
  echo -e "${RED}✗ Validation failed with $ERRORS error(s)${NC}"
  exit 1
fi
