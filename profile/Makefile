.ONESHELL:
.SHELL := /bin/sh
.PHONY: help all zsh neovim tmux
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

all: zsh neovim tmux ## Install all profiles (ZSH, Neovim, Tmux)
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

neovim: ## Install Neovim/Vim configuration
	@echo "Installing Neovim/Vim configuration..."
	@mkdir -p ${HOME}/.config/nvim
	@ln -s -f ${PROFILE}/vimrc ${HOME}/.config/nvim/init.vim
	@ln -s -f ${PROFILE}/vimrc ${HOME}/.vimrc
	@echo "Neovim/Vim configuration installed!"
