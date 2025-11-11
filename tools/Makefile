# Makefile for installing CLI tools via ASDF and Homebrew
# Optimized for macOS

.ONESHELL:
SHELL := /bin/bash
.SHELLFLAGS := -e -u -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: help all asdf-plugins brew-tools python nodejs terraform kubernetes docker aws gcloud azure all-tools

.DEFAULT_GOAL := help

# Colors
BOLD := $(shell tput bold)
GREEN := $(shell tput setaf 2)
YELLOW := $(shell tput setaf 3)
RED := $(shell tput setaf 1)
RESET := $(shell tput sgr0)

# Check if ASDF is available
ASDF_EXISTS := $(shell command -v asdf 2>/dev/null)

help: ## Show this help message
	@echo ""
	@echo "$(BOLD)Tools Installation Makefile$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-30s$(RESET) %s\n", $$1, $$2}'
	@echo ""

check-asdf: ## Check if ASDF is installed
	@if [ -z "$(ASDF_EXISTS)" ]; then \
		echo "$(RED)✗ ASDF not found. Please install it first:$(RESET)"; \
		echo "  make asdf (in parent Makefile)"; \
		exit 1; \
	else \
		echo "$(GREEN)✓ ASDF found at $(ASDF_EXISTS)$(RESET)"; \
	fi

brew-tools: ## Install essential CLI tools via Homebrew
	@echo "$(BOLD)Installing CLI tools via Homebrew...$(RESET)"
	@brew install --quiet wget curl jq yq
	@brew install --quiet gh git-lfs
	@brew install --quiet bat lsd exa fd ripgrep fzf
	@brew install --quiet htop btop dust duf procs
	@brew install --quiet tree tldr thefuck
	@echo "$(GREEN)✓ Homebrew tools installed!$(RESET)"

asdf-plugins: check-asdf ## Install common ASDF plugins
	@echo "$(BOLD)Installing ASDF plugins...$(RESET)"
	@for plugin in python nodejs ruby golang rust terraform kubectl helm kind kubectx krew awscli gcloud azure-cli; do \
		if asdf plugin list | grep -q "^$$plugin$$"; then \
			echo "$(GREEN)✓$(RESET) $$plugin plugin already installed"; \
		else \
			echo "$(YELLOW)Installing $$plugin plugin...$(RESET)"; \
			asdf plugin add $$plugin 2>/dev/null || echo "$(YELLOW)⚠ Could not add $$plugin (might not exist)$(RESET)"; \
		fi; \
	done
	@echo "$(GREEN)✓ ASDF plugins installed!$(RESET)"

python: check-asdf ## Install Python via ASDF (latest)
	@echo "$(BOLD)Installing Python...$(RESET)"
	@if ! asdf plugin list | grep -q "^python$$"; then \
		asdf plugin add python; \
	fi
	@LATEST=$$(asdf list all python | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$$' | tail -1); \
	echo "Installing Python $$LATEST..."; \
	asdf install python $$LATEST; \
	asdf global python $$LATEST
	@echo "$(GREEN)✓ Python installed: $$(python --version)$(RESET)"

nodejs: check-asdf ## Install Node.js via ASDF (LTS)
	@echo "$(BOLD)Installing Node.js...$(RESET)"
	@if ! asdf plugin list | grep -q "^nodejs$$"; then \
		asdf plugin add nodejs; \
	fi
	@LATEST=$$(asdf list all nodejs | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$$' | grep -E '^(18|20|22)\.' | tail -1); \
	echo "Installing Node.js $$LATEST..."; \
	asdf install nodejs $$LATEST; \
	asdf global nodejs $$LATEST
	@echo "$(GREEN)✓ Node.js installed: $$(node --version)$(RESET)"

terraform: check-asdf ## Install Terraform via ASDF (latest)
	@echo "$(BOLD)Installing Terraform...$(RESET)"
	@if ! asdf plugin list | grep -q "^terraform$$"; then \
		asdf plugin add terraform; \
	fi
	@LATEST=$$(asdf list all terraform | grep -v - | tail -1); \
	echo "Installing Terraform $$LATEST..."; \
	asdf install terraform $$LATEST; \
	asdf global terraform $$LATEST
	@echo "$(GREEN)✓ Terraform installed: $$(terraform version -json | jq -r .terraform_version)$(RESET)"

kubernetes: check-asdf ## Install Kubernetes tools (kubectl, helm, kind, kubectx, krew)
	@echo "$(BOLD)Installing Kubernetes tools...$(RESET)"
	@# kubectl
	@if ! asdf plugin list | grep -q "^kubectl$$"; then \
		asdf plugin add kubectl; \
	fi
	@LATEST=$$(asdf list all kubectl | grep -v - | tail -1); \
	asdf install kubectl $$LATEST 2>/dev/null || true; \
	asdf global kubectl $$LATEST 2>/dev/null || true
	@# helm
	@if ! asdf plugin list | grep -q "^helm$$"; then \
		asdf plugin add helm; \
	fi
	@LATEST=$$(asdf list all helm | grep -v - | tail -1); \
	asdf install helm $$LATEST 2>/dev/null || true; \
	asdf global helm $$LATEST 2>/dev/null || true
	@# kind
	@if ! asdf plugin list | grep -q "^kind$$"; then \
		asdf plugin add kind; \
	fi
	@LATEST=$$(asdf list all kind | grep -v - | tail -1); \
	asdf install kind $$LATEST 2>/dev/null || true; \
	asdf global kind $$LATEST 2>/dev/null || true
	@# kubectx
	@if ! asdf plugin list | grep -q "^kubectx$$"; then \
		asdf plugin add kubectx; \
	fi
	@LATEST=$$(asdf list all kubectx | grep -v - | tail -1); \
	asdf install kubectx $$LATEST 2>/dev/null || true; \
	asdf global kubectx $$LATEST 2>/dev/null || true
	@# krew
	@if ! asdf plugin list | grep -q "^krew$$"; then \
		asdf plugin add krew; \
	fi
	@LATEST=$$(asdf list all krew | grep -v - | tail -1); \
	asdf install krew $$LATEST 2>/dev/null || true; \
	asdf global krew $$LATEST 2>/dev/null || true
	@echo "$(GREEN)✓ Kubernetes tools installed!$(RESET)"
	@echo "  kubectl: $$(kubectl version --client -o json 2>/dev/null | jq -r .clientVersion.gitVersion || echo 'N/A')"
	@echo "  helm: $$(helm version --short 2>/dev/null || echo 'N/A')"
	@echo "  kind: $$(kind version 2>/dev/null || echo 'N/A')"

docker: ## Install Docker via Homebrew
	@echo "$(BOLD)Installing Docker...$(RESET)"
	@if brew list --cask docker &>/dev/null; then \
		echo "$(GREEN)✓ Docker already installed$(RESET)"; \
	else \
		brew install --cask docker; \
		echo "$(GREEN)✓ Docker installed!$(RESET)"; \
	fi

aws: check-asdf ## Install AWS CLI via ASDF
	@echo "$(BOLD)Installing AWS CLI...$(RESET)"
	@if ! asdf plugin list | grep -q "^awscli$$"; then \
		asdf plugin add awscli; \
	fi
	@LATEST=$$(asdf list all awscli | tail -1); \
	asdf install awscli $$LATEST 2>/dev/null || true; \
	asdf global awscli $$LATEST 2>/dev/null || true
	@echo "$(GREEN)✓ AWS CLI installed: $$(aws --version 2>&1 || echo 'N/A')$(RESET)"

gcloud: ## Install Google Cloud SDK via Homebrew
	@echo "$(BOLD)Installing Google Cloud SDK...$(RESET)"
	@if brew list --cask google-cloud-sdk &>/dev/null; then \
		echo "$(GREEN)✓ gcloud already installed$(RESET)"; \
	else \
		brew install --cask google-cloud-sdk; \
		echo "$(GREEN)✓ Google Cloud SDK installed!$(RESET)"; \
	fi

azure: ## Install Azure CLI via Homebrew
	@echo "$(BOLD)Installing Azure CLI...$(RESET)"
	@if brew list azure-cli &>/dev/null; then \
		echo "$(GREEN)✓ azure-cli already installed$(RESET)"; \
	else \
		brew install azure-cli; \
		echo "$(GREEN)✓ Azure CLI installed!$(RESET)"; \
	fi

golang: check-asdf ## Install Go via ASDF (latest)
	@echo "$(BOLD)Installing Go...$(RESET)"
	@if ! asdf plugin list | grep -q "^golang$$"; then \
		asdf plugin add golang; \
	fi
	@LATEST=$$(asdf list all golang | grep -v - | tail -1); \
	echo "Installing Go $$LATEST..."; \
	asdf install golang $$LATEST; \
	asdf global golang $$LATEST
	@echo "$(GREEN)✓ Go installed: $$(go version)$(RESET)"

rust: check-asdf ## Install Rust via ASDF (latest)
	@echo "$(BOLD)Installing Rust...$(RESET)"
	@if ! asdf plugin list | grep -q "^rust$$"; then \
		asdf plugin add rust; \
	fi
	@LATEST=$$(asdf list all rust | grep -v - | tail -1); \
	echo "Installing Rust $$LATEST..."; \
	asdf install rust $$LATEST; \
	asdf global rust $$LATEST
	@echo "$(GREEN)✓ Rust installed: $$(rustc --version)$(RESET)"

ruby: check-asdf ## Install Ruby via ASDF (latest)
	@echo "$(BOLD)Installing Ruby...$(RESET)"
	@if ! asdf plugin list | grep -q "^ruby$$"; then \
		asdf plugin add ruby; \
	fi
	@LATEST=$$(asdf list all ruby | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$$' | tail -1); \
	echo "Installing Ruby $$LATEST..."; \
	asdf install ruby $$LATEST; \
	asdf global ruby $$LATEST
	@echo "$(GREEN)✓ Ruby installed: $$(ruby --version)$(RESET)"

all-tools: brew-tools asdf-plugins ## Install all CLI tools (interactive selection)
	@echo ""
	@echo "$(BOLD)Select tools to install:$(RESET)"
	@echo ""
	@read -p "Install Python? [y/N]: " -n 1 -r REPLY; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then $(MAKE) python; fi
	@read -p "Install Node.js? [y/N]: " -n 1 -r REPLY; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then $(MAKE) nodejs; fi
	@read -p "Install Go? [y/N]: " -n 1 -r REPLY; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then $(MAKE) golang; fi
	@read -p "Install Rust? [y/N]: " -n 1 -r REPLY; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then $(MAKE) rust; fi
	@read -p "Install Ruby? [y/N]: " -n 1 -r REPLY; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then $(MAKE) ruby; fi
	@read -p "Install Terraform? [y/N]: " -n 1 -r REPLY; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then $(MAKE) terraform; fi
	@read -p "Install Kubernetes tools? [y/N]: " -n 1 -r REPLY; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then $(MAKE) kubernetes; fi
	@read -p "Install Docker? [y/N]: " -n 1 -r REPLY; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then $(MAKE) docker; fi
	@read -p "Install AWS CLI? [y/N]: " -n 1 -r REPLY; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then $(MAKE) aws; fi
	@read -p "Install Google Cloud SDK? [y/N]: " -n 1 -r REPLY; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then $(MAKE) gcloud; fi
	@read -p "Install Azure CLI? [y/N]: " -n 1 -r REPLY; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then $(MAKE) azure; fi
	@echo ""
	@echo "$(GREEN)$(BOLD)✓ All selected tools installed!$(RESET)"

all: brew-tools asdf-plugins python nodejs terraform kubernetes ## Install essential tools (non-interactive)
	@echo ""
	@echo "$(GREEN)$(BOLD)✓ Essential tools installation complete!$(RESET)"

list: check-asdf ## List installed ASDF tools and versions
	@echo "$(BOLD)Installed ASDF tools:$(RESET)"
	@asdf current

update: check-asdf ## Update all ASDF plugins
	@echo "$(BOLD)Updating ASDF plugins...$(RESET)"
	@asdf plugin update --all
	@echo "$(GREEN)✓ All plugins updated!$(RESET)"
