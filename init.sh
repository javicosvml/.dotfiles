#!/bin/bash
# init.sh - Complete integrity and functionality test for dotfiles repository
# This script validates structure, syntax, and executes portable Makefile targets

set -e

# ============================================================================
# Color definitions
# ============================================================================
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# ============================================================================
# Counters
# ============================================================================
ERRORS=0
WARNINGS=0
TESTS_PASSED=0
TESTS_TOTAL=0

# ============================================================================
# Helper functions
# ============================================================================
error() {
    echo -e "${RED}✗ ERROR: $1${RESET}"
    ERRORS=$((ERRORS + 1))
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
}

warning() {
    echo -e "${YELLOW}⚠ WARNING: $1${RESET}"
    WARNINGS=$((WARNINGS + 1))
}

success() {
    echo -e "${GREEN}✓ $1${RESET}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
}

info() {
    echo -e "${BLUE}ℹ $1${RESET}"
}

section() {
    echo ""
    echo -e "${BOLD}=== $1 ===${RESET}"
    echo ""
}

# ============================================================================
# Test functions
# ============================================================================

test_directory_structure() {
    section "1. Testing Directory Structure"

    local required_dirs=(
        "zsh.d"
        "nvim"
        "nvim/lua"
        "nvim/lua/config"
        "nvim/lua/plugins"
    )

    for dir in "${required_dirs[@]}"; do
        if [ -d "$HOME/.dotfiles/$dir" ]; then
            success "Directory exists: $dir"
        else
            error "Directory missing: $dir"
        fi
    done
}

test_critical_files() {
    section "2. Testing Critical Files"

    local required_files=(
        "Makefile"
        "README.md"
        ".gitignore"
        "zshrc"
        "tmux.conf"
        "gitignore_global"
        "kitty.conf"
        "nvim/init.lua"
    )

    for file in "${required_files[@]}"; do
        if [ -f "$HOME/.dotfiles/$file" ]; then
            success "File exists: $file"
        else
            error "File missing: $file"
        fi
    done
}

test_makefile_syntax() {
    section "3. Testing Makefile Syntax"

    info "Validating Makefile syntax with dry-run..."

    if make -n -f "$HOME/.dotfiles/Makefile" help &>/dev/null; then
        success "Makefile syntax is valid"
    else
        error "Makefile has syntax errors"
        return
    fi

    # Test all major targets with dry-run
    local targets=(
        "help"
        "profile"
        "zsh"
        "neovim"
        "tmux"
        "git"
        "clean"
    )

    for target in "${targets[@]}"; do
        if make -n -f "$HOME/.dotfiles/Makefile" "$target" &>/dev/null; then
            success "Target '$target' dry-run successful"
        else
            error "Target '$target' dry-run failed"
        fi
    done
}

test_zsh_syntax() {
    section "4. Testing ZSH Configuration Syntax"

    # Test main zshrc
    if [ -f "$HOME/.dotfiles/zshrc" ]; then
        if zsh -n "$HOME/.dotfiles/zshrc" 2>/dev/null; then
            success "zshrc syntax is valid"
        else
            error "zshrc has syntax errors"
        fi
    fi

    # Test modular ZSH files
    if [ -d "$HOME/.dotfiles/zsh.d" ]; then
        for file in "$HOME/.dotfiles/zsh.d"/*.zsh; do
            if [ -f "$file" ]; then
                if zsh -n "$file" 2>/dev/null; then
                    success "$(basename "$file") syntax is valid"
                else
                    error "$(basename "$file") has syntax errors"
                fi
            fi
        done
    fi
}

test_lua_syntax() {
    section "5. Testing Neovim Lua Configuration Syntax"

    if ! command -v nvim &>/dev/null; then
        warning "Neovim not found, skipping Lua syntax tests"
        return
    fi

    # Basic syntax check for init.lua
    if [ -f "$HOME/.dotfiles/nvim/init.lua" ]; then
        if lua -e "dofile('$HOME/.dotfiles/nvim/init.lua')" 2>/dev/null; then
            success "init.lua syntax is valid"
        else
            warning "init.lua has potential issues (may require plugins)"
        fi
    fi
}

test_file_permissions() {
    section "6. Testing File Permissions"

    local critical_files=(
        "Makefile"
        "zshrc"
        "tmux.conf"
        "gitignore_global"
    )

    for file in "${critical_files[@]}"; do
        if [ -r "$HOME/.dotfiles/$file" ]; then
            success "File is readable: $file"
        else
            error "File is not readable: $file"
        fi
    done
}

execute_profile_targets() {
    section "7. Executing Portable Makefile Targets"

    info "Changing to dotfiles directory..."
    cd "$HOME/.dotfiles" || {
        error "Cannot change to dotfiles directory"
        return
    }

    # Override DOTFILES variable for testing
    export DOTFILES="$HOME/.dotfiles"

    info "Executing: make profile"
    if make -f "$HOME/.dotfiles/Makefile" profile 2>&1 | tee /tmp/make-profile.log; then
        success "make profile executed successfully"
    else
        error "make profile failed (see /tmp/make-profile.log)"
        cat /tmp/make-profile.log
    fi
}

verify_symlinks() {
    section "8. Verifying Symlink Creation"

    local expected_symlinks=(
        "$HOME/.zshrc:$HOME/.dotfiles/zshrc"
        "$HOME/.zsh.d:$HOME/.dotfiles/zsh.d"
        "$HOME/.tmux.conf:$HOME/.dotfiles/tmux.conf"
        "$HOME/.gitignore_global:$HOME/.dotfiles/gitignore_global"
        "$HOME/.config/nvim:$HOME/.dotfiles/nvim"
    )

    for entry in "${expected_symlinks[@]}"; do
        local link="${entry%%:*}"
        local target="${entry##*:}"

        if [ -L "$link" ]; then
            local actual_target
            actual_target=$(readlink "$link")
            if [ "$actual_target" = "$target" ]; then
                success "Symlink correct: $link → $target"
            else
                error "Symlink points to wrong target: $link → $actual_target (expected $target)"
            fi
        else
            error "Symlink not created: $link"
        fi
    done
}

verify_configurations() {
    section "9. Verifying Configuration Files Post-Installation"

    # Verify ZSH config is accessible
    if [ -f "$HOME/.zshrc" ]; then
        if zsh -n "$HOME/.zshrc" 2>/dev/null; then
            success "Installed .zshrc is valid"
        else
            error "Installed .zshrc has syntax errors"
        fi
    else
        error ".zshrc not found in HOME"
    fi

    # Verify tmux config is accessible
    if [ -f "$HOME/.tmux.conf" ]; then
        success "Installed .tmux.conf is accessible"
    else
        error ".tmux.conf not found in HOME"
    fi

    # Verify Neovim config is accessible
    if [ -d "$HOME/.config/nvim" ]; then
        if [ -f "$HOME/.config/nvim/init.lua" ]; then
            success "Installed Neovim configuration is accessible"
        else
            error "init.lua not found in installed Neovim config"
        fi
    else
        error "Neovim config directory not found"
    fi

    # Verify Git configuration
    if [ -f "$HOME/.gitignore_global" ]; then
        success "Git global ignore file is accessible"
    else
        error ".gitignore_global not found in HOME"
    fi
}

test_makefile_targets() {
    section "10. Testing Makefile Target Definitions"

    local required_targets=(
        "help"
        "all"
        "profile"
        "zsh"
        "neovim"
        "tmux"
        "git"
        "clean"
    )

    for target in "${required_targets[@]}"; do
        if grep -q "^${target}:" "$HOME/.dotfiles/Makefile"; then
            success "Target defined: $target"
        else
            error "Target missing: $target"
        fi
    done
}

cleanup_test() {
    section "11. Testing Cleanup (Dry-run)"

    info "Testing cleanup target with dry-run..."
    if make -n -f "$HOME/.dotfiles/Makefile" clean &>/dev/null; then
        success "Cleanup target dry-run successful"
    else
        error "Cleanup target dry-run failed"
    fi
}

# ============================================================================
# Main execution
# ============================================================================

main() {
    clear
    echo -e "${BOLD}╔════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BOLD}║     Dotfiles Repository - Complete Integrity Test Suite      ║${RESET}"
    echo -e "${BOLD}╚════════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    info "Test Environment: $(uname -s) $(uname -r)"
    info "Shell: $(basename "$SHELL")"
    info "User: $(whoami)"
    info "Home: $HOME"
    echo ""

    # Run all tests
    test_directory_structure
    test_critical_files
    test_makefile_syntax
    test_zsh_syntax
    test_lua_syntax
    test_file_permissions
    test_makefile_targets
    execute_profile_targets
    verify_symlinks
    verify_configurations
    cleanup_test

    # Final report
    section "Test Summary"

    echo -e "${BOLD}Results:${RESET}"
    echo -e "  Tests Passed:  ${GREEN}$TESTS_PASSED${RESET} / $TESTS_TOTAL"
    echo -e "  Errors:        ${RED}$ERRORS${RESET}"
    echo -e "  Warnings:      ${YELLOW}$WARNINGS${RESET}"
    echo ""

    if [ $ERRORS -eq 0 ]; then
        echo -e "${GREEN}${BOLD}╔════════════════════════════════════════════════════════════════╗${RESET}"
        echo -e "${GREEN}${BOLD}║  ✓ ALL TESTS PASSED - Repository integrity verified          ║${RESET}"
        echo -e "${GREEN}${BOLD}╚════════════════════════════════════════════════════════════════╝${RESET}"
        exit 0
    else
        echo -e "${RED}${BOLD}╔════════════════════════════════════════════════════════════════╗${RESET}"
        echo -e "${RED}${BOLD}║  ✗ TESTS FAILED - Found $ERRORS error(s)                         ║${RESET}"
        echo -e "${RED}${BOLD}╚════════════════════════════════════════════════════════════════╝${RESET}"
        exit 1
    fi
}

# Run main function
main
