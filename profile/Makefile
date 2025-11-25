.ONESHELL:
.SHELL := /bin/sh
.PHONY: help all zsh neovim tmux git
.DEFAULT_GOAL := help
CURRENT_FOLDER = $(shell basename "$$(pwd)")
BOLD = $(shell tput bold)
RED = $(shell tput setaf 1)
RESET = $(shell tput sgr0)

## Global
NAME = profile
VERSION = scratch

## Paths
DOTFILES = ${HOME}/.dotfiles
PROFILE = ${DOTFILES}/profile

help: ## Show this help message
	@echo ""
	@echo "$(BOLD)Profile Configuration for macOS$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: zsh neovim tmux git ## Install all profiles (ZSH, Neovim, Tmux, Git)
	@echo "✓ Local environment successfully configured for macOS"

tmux: ## Install Tmux configuration
	@echo "Installing Tmux configuration..."
	@ln -s -f ${PROFILE}/tmux.conf ${HOME}/.tmux.conf
	@ln -s -f ${PROFILE}/tmux.local ${HOME}/.tmux.conf.local
	@echo "Tmux configuration installed!"

zsh: ## Install ZSH configuration
	@echo "Installing ZSH configuration..."
	@if [ -f "${HOME}/.zshrc" ]; then rm ${HOME}/.zshrc; fi
	@if [ -d "${HOME}/.zsh.d" ]; then rm -rf ${HOME}/.zsh.d; fi
	@ln -s -f ${PROFILE}/zshrc ${HOME}/.zshrc
	@ln -s -f ${PROFILE}/zsh.d ${HOME}/.zsh.d
	@echo "ZSH configuration installed!"

neovim: ## Install Neovim configuration (Lua-based)
	@echo "Installing Neovim configuration..."
	@mkdir -p ${HOME}/.config
	@rm -rf ${HOME}/.config/nvim
	@ln -s -f ${PROFILE}/nvim ${HOME}/.config/nvim
	@echo "Neovim configuration installed!"
	@echo "  Run 'nvim' to install plugins automatically"

git: ## Install Git configuration (gitconfig, gitignore_global, editorconfig)
	@echo "Installing Git configuration..."
	@ln -s -f ${PROFILE}/gitconfig ${HOME}/.gitconfig
	@ln -s -f ${PROFILE}/gitignore_global ${HOME}/.gitignore_global
	@ln -s -f ${PROFILE}/editorconfig ${HOME}/.editorconfig
	@echo "Git configuration installed!"
	@echo "  Note: Set your name/email in ~/.gitconfig.local"
