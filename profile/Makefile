# Makefile for profile installation on macOS
# Installs ZSH, Neovim, Tmux, and Git configurations

# Make configuration
.ONESHELL:
SHELL := /bin/bash
.SHELLFLAGS := -e -u -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Phony targets
.PHONY: help all zsh neovim tmux git

# Default target
.DEFAULT_GOAL := help

# Variables
BOLD := $(shell tput bold)
GREEN := $(shell tput setaf 2)
YELLOW := $(shell tput setaf 3)
RED := $(shell tput setaf 1)
RESET := $(shell tput sgr0)

# Paths
DOTFILES := $(HOME)/.dotfiles
PROFILE := $(DOTFILES)/profile

# Targets
help: ## Show this help message
	@echo ""
	@echo "$(BOLD)Profile Configuration for macOS$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-30s$(RESET) %s\n", $$1, $$2}'

all: zsh neovim tmux git ## Install all profiles (ZSH, Neovim, Tmux, Git)
	@echo "$(GREEN)$(BOLD)✓ Local environment successfully configured for macOS$(RESET)"

tmux: ## Install Tmux configuration
	@echo "$(BOLD)Installing Tmux configuration...$(RESET)"
	@ln -sf $(PROFILE)/tmux.conf $(HOME)/.tmux.conf
	@ln -sf $(PROFILE)/tmux.local $(HOME)/.tmux.conf.local
	@echo "$(GREEN)✓ Tmux configuration installed$(RESET)"

zsh: ## Install ZSH configuration
	@echo "$(BOLD)Installing ZSH configuration...$(RESET)"
	@if [ -f "$(HOME)/.zshrc" ]; then rm $(HOME)/.zshrc; fi
	@if [ -d "$(HOME)/.zsh.d" ]; then rm -rf $(HOME)/.zsh.d; fi
	@ln -sf $(PROFILE)/zshrc $(HOME)/.zshrc
	@ln -sf $(PROFILE)/zsh.d $(HOME)/.zsh.d
	@echo "$(GREEN)✓ ZSH configuration installed$(RESET)"

neovim: ## Install Neovim configuration (Lua-based)
	@echo "$(BOLD)Installing Neovim configuration...$(RESET)"
	@mkdir -p $(HOME)/.config
	@rm -rf $(HOME)/.config/nvim
	@ln -sf $(PROFILE)/nvim $(HOME)/.config/nvim
	@echo "$(GREEN)✓ Neovim configuration installed$(RESET)"
	@echo "$(YELLOW)  Run 'nvim' to install plugins automatically$(RESET)"

git: ## Install Git configuration (gitconfig, gitignore_global, editorconfig)
	@echo "$(BOLD)Installing Git configuration...$(RESET)"
	@ln -sf $(PROFILE)/gitconfig $(HOME)/.gitconfig
	@ln -sf $(PROFILE)/gitignore_global $(HOME)/.gitignore_global
	@ln -sf $(PROFILE)/editorconfig $(HOME)/.editorconfig
	@echo "$(GREEN)✓ Git configuration installed$(RESET)"
	@echo "$(YELLOW)  Note: Set your name/email in ~/.gitconfig.local$(RESET)"
