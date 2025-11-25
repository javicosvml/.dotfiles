# Makefile for dotfiles installation on macOS
# Uses Homebrew for package management

# Make configuration
.ONESHELL:
SHELL := /bin/bash
.SHELLFLAGS := -e -u -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Phony targets (targets that don't represent files)
.PHONY: help all brew profile asdf tools kitty clean

# Default target
.DEFAULT_GOAL := help

# Variables
CURRENT_FOLDER := $(shell basename "$$(pwd)")
BOLD := $(shell tput bold)
RED := $(shell tput setaf 1)
GREEN := $(shell tput setaf 2)
YELLOW := $(shell tput setaf 3)
RESET := $(shell tput sgr0)

# Global
NAME := main
VERSION := scratch
OS := $(shell uname -s)

# Paths
DOTFILES := $(HOME)/.dotfiles
CONFIG_DIR := $(HOME)/.config
KITTY_CONFIG := $(CONFIG_DIR)/kitty

# Targets
help: ## Show this help message
	@echo ""
	@echo "$(BOLD)Dotfiles Makefile - macOS$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-30s$(RESET) %s\n", $$1, $$2}'
	@echo ""

brew: ## Install Homebrew package manager
	@echo "$(BOLD)Checking Homebrew installation...$(RESET)"
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "$(YELLOW)Homebrew not found. Installing...$(RESET)"; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		echo ""; \
		echo "$(BOLD)Configuring Homebrew in PATH...$(RESET)"; \
		if [ "$$(uname -m)" = "arm64" ]; then \
			echo 'eval "$$(/opt/homebrew/bin/brew shellenv)"' >> $(HOME)/.zprofile; \
			eval "$$(/opt/homebrew/bin/brew shellenv)"; \
		else \
			echo 'eval "$$(/usr/local/bin/brew shellenv)"' >> $(HOME)/.zprofile; \
			eval "$$(/usr/local/bin/brew shellenv)"; \
		fi; \
		echo "$(GREEN)✓ Homebrew installed successfully!$(RESET)"; \
	else \
		echo "$(GREEN)✓ Homebrew already installed at $$(which brew)$(RESET)"; \
		echo "Version: $$(brew --version | head -n 1)"; \
	fi

all: brew profile tools kitty ## Install all components (full setup)

profile: ## Install ZSH, Tmux, and Neovim profiles
	@echo "$(BOLD)Installing profiles...$(RESET)"
	@$(MAKE) --no-print-directory all -C profile

tools: asdf ## Install development tools with ASDF
	@echo "$(BOLD)Installing tools...$(RESET)"
	@$(MAKE) --no-print-directory all -C tools

kitty: brew ## Install Kitty terminal emulator and configuration
	@echo "$(BOLD)Installing Kitty terminal emulator...$(RESET)"
	@if ! command -v kitty >/dev/null 2>&1; then \
		echo "$(YELLOW)Installing Kitty terminal...$(RESET)"; \
		brew install --cask kitty; \
	else \
		echo "$(GREEN)✓ Kitty already installed$(RESET)"; \
	fi
	@echo ""
	@echo "$(BOLD)Installing JetBrains Mono font...$(RESET)"
	@brew tap homebrew/cask-fonts 2>/dev/null || true
	@if ! brew list --cask font-jetbrains-mono >/dev/null 2>&1; then \
		echo "$(YELLOW)Installing font...$(RESET)"; \
		brew install --cask font-jetbrains-mono; \
	else \
		echo "$(GREEN)✓ JetBrains Mono font already installed$(RESET)"; \
	fi
	@echo ""
	@echo "$(BOLD)Linking Kitty configuration...$(RESET)"
	@mkdir -p $(KITTY_CONFIG)
	@ln -sf $(DOTFILES)/config/kitty/kitty.conf $(KITTY_CONFIG)/kitty.conf
	@echo "$(GREEN)✓ Kitty configuration linked$(RESET)"
	@echo ""
	@echo "$(GREEN)$(BOLD)✓ Kitty setup complete!$(RESET)"

asdf: brew ## Install ASDF version manager (v0.18.0+ from Homebrew)
	@echo "$(BOLD)Installing ASDF version manager...$(RESET)"
	@if ! brew list asdf >/dev/null 2>&1; then \
		echo "$(YELLOW)Installing ASDF via Homebrew...$(RESET)"; \
		brew install asdf; \
		ASDF_VERSION=$$(brew list --versions asdf | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'); \
		echo ""; \
		echo "$(BOLD)Configuring ASDF for ZSH...$(RESET)"; \
		if [ -f "$(HOME)/.zshrc" ]; then \
			if ! grep -q "asdf.sh" "$(HOME)/.zshrc"; then \
				echo "" >> $(HOME)/.zshrc; \
				echo "# ASDF Version Manager (v$$ASDF_VERSION - managed by Homebrew)" >> $(HOME)/.zshrc; \
				echo ". $$(brew --prefix asdf)/libexec/asdf.sh" >> $(HOME)/.zshrc; \
				echo "fpath=($$(brew --prefix asdf)/share/zsh/site-functions \$$fpath)" >> $(HOME)/.zshrc; \
				echo "$(GREEN)✓ ASDF configuration added to .zshrc$(RESET)"; \
			else \
				echo "$(GREEN)✓ ASDF already configured in .zshrc$(RESET)"; \
			fi; \
		fi; \
		echo "$(GREEN)✓ ASDF v$$ASDF_VERSION installed successfully!$(RESET)"; \
		echo ""; \
		echo "$(YELLOW)To activate ASDF now, run:$(RESET)"; \
		echo "  source ~/.zshrc"; \
		echo ""; \
		echo "$(YELLOW)Then install tools with:$(RESET)"; \
		echo "  cd tools && make help"; \
	else \
		ASDF_VERSION=$$(brew list --versions asdf | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'); \
		echo "$(GREEN)✓ ASDF v$$ASDF_VERSION already installed$(RESET)"; \
		echo "Location: $$(brew --prefix asdf)"; \
		echo ""; \
		echo "$(YELLOW)To update ASDF:$(RESET) brew upgrade asdf"; \
		echo "$(YELLOW)To update plugins:$(RESET) cd tools && make update"; \
	fi
	@echo ""
	@echo "$(BOLD)Verifying ASDF installation...$(RESET)"
	@if command -v asdf >/dev/null 2>&1; then \
		echo "$(GREEN)✓ ASDF is active: $$(asdf --version | head -1)$(RESET)"; \
	else \
		echo "$(YELLOW)⚠ ASDF installed but not yet in PATH$(RESET)"; \
		echo "  Run: source ~/.zshrc"; \
	fi

clean: ## Remove symbolic links and temporary files
	@echo "$(BOLD)Cleaning up...$(RESET)"
	@echo "$(YELLOW)This will remove symlinked configurations$(RESET)"
	@rm -f $(KITTY_CONFIG)/kitty.conf
	@echo "$(GREEN)✓ Cleanup complete$(RESET)"
