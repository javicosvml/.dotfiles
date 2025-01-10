.ONESHELL:
.SHELL:=/bin/sh
.PHONY: help all profile asdf
.DEFAULT_GOAL:=help
CURRENT_FOLDER=$(shell basename "$$(pwd)")
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
RESET=$(shell tput sgr0)

## Global
NAME=main
VERSION=scratch
OS=$(shell uname -s)

## Paths
DOTFILES=${HOME}/.dotfiles

## Burn, baby, burn
help: ## Shows this makefile help
	@echo ""
	@echo "$(BOLD)Klaatu Barata Nitko!$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: asdf profile ## Install everything

profile: ## Install ZSH, Tmux, and Neovim profiles
	$(MAKE) all -C profile

asdf: ## Install ASDF
	@echo "Installing ASDF"
	rm -rf ${HOME}/.asdf && \
	git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf && \
	echo "ASDF done!"
