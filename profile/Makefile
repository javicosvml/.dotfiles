.ONESHELL:
.SHELL := /bin/sh
.PHONY: help
.DEFAULT_GOAL := help
CURRENT_FOLDER=$(shell basename "$$(pwd)")
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
RESET=$(shell tput sgr0)

## Global
NAME=profile
VERSION=scratch

## Paths
DOTFILES=${HOME}/.dotfiles
PROFILE=${DOTFILES}/profile

help:
	@echo ""
	@echo "Klaatu Barata Nitko!"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: zsh neovim tmux
	@echo "Local environment succesfully configured"

tmux:
	@if [ -d "${HOME}/.tmux.git" ]; then rm -rf ${HOME}/.tmux.git; fi
	@git clone https://github.com/gpakosz/.tmux.git ${HOME}/.tmux.git
	@ln -s -f ${HOME}/.tmux.git/.tmux.conf ${HOME}/.tmux.conf
	@ln -s -f ${HOME}/.tmux.git/.tmux.conf.local ${HOME}/.tmux.conf.local

zsh:
	@if [ -f "${HOME}/.zshrc" ]; then rm ${HOME}/.zshrc; fi
	@if [ -d "${HOME}/.zsh.d" ]; then rm -rf ${HOME}/.zsh.d; fi
	@sh -c "ln -s -f ${PROFILE}/zshrc ${HOME}/.zshrc"
	@sh -c "ln -s -f ${PROFILE}/zsh.d ${HOME}/.zsh.d"

neovim:
	@mkdir -p ~/.config/nvim
	@ln -s -f ${PROFILE}/vimrc ${HOME}/.config/nvim/init.vim
	@ln -s -f ${PROFILE}/vimrc ${HOME}/.vimrc
