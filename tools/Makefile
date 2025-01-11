.ONESHELL:
.SHELL := /bin/sh
.PHONY: help
.DEFAULT_GOAL := help
CURRENT_FOLDER=$(shell basename "$$(pwd)")
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
RESET=$(shell tput sgr0)

## Global
NAME=tools
VERSION=scratch

## Paths
DOTFILES=${HOME}/.dotfiles
TOOLS=${DOTFILES}/tools
ASDF=${HOME}/.asdf/bin/asdf

help:
	@echo ""
	@echo "Klaatu Barata Nitko!"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: terraform kubernetes

## Terraform
terraform: ## Install Terraform
	${ASDF} plugin-add terraform ;\
	${ASDF} install terraform latest ;\
	${ASDF} global terraform latest

## Kubernetes
kubernetes: kubectl kubectx helm kind krew ## Install Kubernetes tools: Kubectl & Helm
	@echo "Kubernetes tools enabled."

kubectl: ## Install Kubectl
	${ASDF} plugin-add kubectl ;\
	${ASDF} install kubectl latest ;\
	${ASDF} global kubectl latest

helm: ## Install Helm
	${ASDF} plugin-add helm ;\
	${ASDF} install helm latest ;\
	${ASDF} global helm latest

kubectx: ## Install Kubectx
	${ASDF} plugin-add kubectx ;\
	${ASDF} install kubectx latest ;\
	${ASDF} global kubectx latest

kind: ## Install Kind (Kubernetes on docker)
	@echo "Installing Kind" ;\
	${ASDF} plugin-add kind ;\
	${ASDF} install kind latest ;\
	${ASDF} global kind latest

krew: ## Install Krew
	${ASDF} plugin-add krew ;\
	${ASDF} install krew latest ;\
	${ASDF} global krew latest

## Containers
docker-compose: ## Install Docker-compose
	@echo "Installing Docker Compose" ;\
	wget -q https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64 -O ${HOME}/bin/docker-compose ;\
	chmod 755 -R ${HOME}/bin/docker-compose ;\
	${HOME}/bin/docker-compose -v
	@echo "Docker compose done!"
