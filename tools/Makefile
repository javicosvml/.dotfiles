# Makefile for installing CLI tools via ASDF and Homebrew
# Updated for ASDF v0.18.0+ (December 2024)
# Breaking changes: 'global/local' replaced with 'set'
# New commands: 'asdf latest', 'asdf set --home'

.ONESHELL:
SHELL := /bin/bash
.SHELLFLAGS := -e -u -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: help all brew-tools install-plugin python nodejs golang rust ruby terraform kubernetes docker aws gcloud azure list update clean

.DEFAULT_GOAL := help

# Colors
BOLD := $(shell tput bold)
GREEN := $(shell tput setaf 2)
YELLOW := $(shell tput setaf 3)
RED := $(shell tput setaf 1)
RESET := $(shell tput sgr0)

# ASDF check
ASDF_EXISTS := $(shell command -v asdf 2>/dev/null)
ASDF_VERSION := $(shell asdf version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)

help: ## Show this help message
	@echo ""
	@echo "$(BOLD)Development Tools Manager - ASDF v0.18.0+$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-30s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)Installed tools:$(RESET)"
	@asdf current 2>/dev/null | tail -n +2 | awk '{if($$2!="______") printf "  • %-12s %s\n", $$1, $$2}' || echo "  No tools installed yet"
	@echo ""

# Check ASDF availability
define check_asdf
	@if [ -z "$(ASDF_EXISTS)" ]; then \
		echo "$(RED)✗ ASDF not found. Install with: cd ~/.dotfiles && make asdf$(RESET)"; \
		exit 1; \
	fi
endef

# Generic plugin installation function
define install_plugin
	@if ! asdf plugin list 2>/dev/null | grep -q "^$(1)$$"; then \
		echo "$(YELLOW)Adding $(1) plugin...$(RESET)"; \
		asdf plugin add $(1) $(2) 2>/dev/null || { echo "$(RED)✗ Failed to add $(1) plugin$(RESET)"; exit 1; }; \
	fi
endef

# Generic tool installation function
define install_tool
	$(call check_asdf)
	$(call install_plugin,$(1),$(2))
	@echo "$(YELLOW)Installing $(1)...$(RESET)"; \
	LATEST=$$(asdf latest $(1) 2>/dev/null); \
	if [ -z "$$LATEST" ]; then \
		echo "$(RED)✗ Could not determine latest $(1) version$(RESET)"; \
		exit 1; \
	fi; \
	if asdf list $(1) 2>/dev/null | grep -q "$$LATEST"; then \
		echo "$(GREEN)✓ $(1) $$LATEST already installed$(RESET)"; \
	else \
		echo "  Installing version $$LATEST..."; \
		if asdf install $(1) $$LATEST 2>&1 | tee /tmp/$(1)-install.log | grep -v "^$$"; then \
			echo "$(GREEN)✓ $(1) $$LATEST installed$(RESET)"; \
		else \
			echo "$(RED)✗ Installation failed. Check /tmp/$(1)-install.log$(RESET)"; \
			exit 1; \
		fi; \
	fi; \
	asdf set --home $(1) $$LATEST 2>/dev/null; \
	asdf reshim $(1) 2>/dev/null
endef

brew-tools: ## Install essential CLI tools via Homebrew
	@echo "$(BOLD)Installing CLI tools via Homebrew...$(RESET)"
	@for tool in wget curl jq yq gh git-lfs bat lsd fd ripgrep fzf htop tree tldr; do \
		if brew list $$tool &>/dev/null; then \
			echo "$(GREEN)✓$(RESET) $$tool"; \
		else \
			echo "$(YELLOW)Installing $$tool...$(RESET)"; \
			brew install --quiet $$tool || brew install $$tool; \
		fi; \
	done
	@echo "$(GREEN)✓ Homebrew tools installed$(RESET)"

python: ## Install Python (latest stable)
	$(call install_tool,python)

nodejs: ## Install Node.js (latest stable)
	$(call install_tool,nodejs)

golang: ## Install Go (latest stable)
	$(call install_tool,golang)

rust: ## Install Rust (latest stable)
	$(call install_tool,rust)

ruby: ## Install Ruby (latest stable)
	$(call install_tool,ruby)

terraform: ## Install Terraform (latest stable)
	$(call install_tool,terraform)

kubectl: ## Install kubectl (latest stable)
	$(call install_tool,kubectl)

helm: ## Install Helm (latest stable)
	$(call install_tool,helm)

kind: ## Install kind - Kubernetes in Docker
	$(call install_tool,kind,https://github.com/reegnz/asdf-kind.git)

kubectx: ## Install kubectx/kubens
	$(call install_tool,kubectx,https://github.com/virtualstaticvoid/asdf-kubectx.git)

aws: ## Install AWS CLI
	$(call install_tool,awscli)

kubernetes: kubectl helm kind kubectx ## Install all Kubernetes tools

docker: ## Install Docker Desktop via Homebrew
	@echo "$(BOLD)Installing Docker Desktop...$(RESET)"
	@if brew list --cask docker &>/dev/null; then \
		echo "$(GREEN)✓ Docker Desktop already installed$(RESET)"; \
	else \
		brew install --cask docker; \
		echo "$(GREEN)✓ Docker Desktop installed$(RESET)"; \
	fi

gcloud: ## Install Google Cloud SDK via Homebrew
	@echo "$(BOLD)Installing Google Cloud SDK...$(RESET)"
	@if brew list --cask google-cloud-sdk &>/dev/null; then \
		echo "$(GREEN)✓ Google Cloud SDK already installed$(RESET)"; \
	else \
		brew install --cask google-cloud-sdk; \
		echo "$(GREEN)✓ Google Cloud SDK installed$(RESET)"; \
	fi

azure: ## Install Azure CLI via Homebrew
	@echo "$(BOLD)Installing Azure CLI...$(RESET)"
	@if brew list azure-cli &>/dev/null; then \
		echo "$(GREEN)✓ Azure CLI already installed$(RESET)"; \
	else \
		brew install azure-cli; \
		echo "$(GREEN)✓ Azure CLI installed$(RESET)"; \
	fi

all: brew-tools python nodejs golang terraform kubernetes ## Install essential development tools
	@echo ""
	@echo "$(GREEN)$(BOLD)✓ Essential tools installed!$(RESET)"
	@echo ""
	@echo "$(YELLOW)Tip: Run 'make list' to see all installed versions$(RESET)"

list: ## List all installed ASDF tools and versions
	$(call check_asdf)
	@echo "$(BOLD)ASDF Version:$(RESET) $(ASDF_VERSION)"
	@echo ""
	@echo "$(BOLD)Installed Tools:$(RESET)"
	@asdf current 2>/dev/null || echo "  No tools installed"

update: ## Update ASDF and all plugins
	$(call check_asdf)
	@echo "$(BOLD)Updating ASDF...$(RESET)"
	@brew upgrade asdf 2>/dev/null || echo "$(GREEN)✓ ASDF up to date$(RESET)"
	@echo ""
	@echo "$(BOLD)Updating plugins...$(RESET)"
	@asdf plugin update --all 2>&1 || true
	@echo "$(GREEN)✓ Update complete$(RESET)"

clean: ## Remove unused ASDF versions
	$(call check_asdf)
	@echo "$(BOLD)Cleaning unused tool versions...$(RESET)"
	@for plugin in $$(asdf plugin list 2>/dev/null); do \
		echo "  Cleaning $$plugin..."; \
		asdf list $$plugin 2>/dev/null | grep -v '*' | xargs -I {} asdf uninstall $$plugin {} 2>/dev/null || true; \
	done
	@echo "$(GREEN)✓ Cleanup complete$(RESET)"
