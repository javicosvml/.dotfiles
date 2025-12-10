# Makefile for dotfiles installation on macOS
# Consolidated: main installation, tools, and profile configuration
# Uses Homebrew for package management and ASDF v0.18.0+ for development tools

# =============================================================================
# Make Configuration
# =============================================================================
.ONESHELL:
SHELL := /bin/bash
.SHELLFLAGS := -e -u -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# =============================================================================
# Phony Targets
# =============================================================================
.PHONY: help all brew asdf kitty clean
.PHONY: profile zsh neovim tmux git
.PHONY: tools brew-tools nodejs golang ruby terraform
.PHONY: kubernetes kubectl helm kind kubectx
.PHONY: docker aws gcloud azure
.PHONY: list update

# =============================================================================
# Default Target
# =============================================================================
.DEFAULT_GOAL := help

# =============================================================================
# Variables
# =============================================================================
# Colors
BOLD := $(shell tput bold)
RED := $(shell tput setaf 1)
GREEN := $(shell tput setaf 2)
YELLOW := $(shell tput setaf 3)
RESET := $(shell tput sgr0)

# Paths
DOTFILES := $(HOME)/.dotfiles
CONFIG_DIR := $(HOME)/.config
KITTY_CONFIG := $(CONFIG_DIR)/kitty

# System info
OS := $(shell uname -s)

# ASDF check
ASDF_EXISTS := $(shell command -v asdf 2>/dev/null)
ASDF_VERSION := $(shell asdf version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)

# =============================================================================
# Helper Functions
# =============================================================================
# Check ASDF availability
define check_asdf
	@if [ -z "$(ASDF_EXISTS)" ]; then \
		echo "$(RED)✗ ASDF not found. Install with: make asdf$(RESET)"; \
		exit 1; \
	fi
endef

# Generic plugin installation function
define install_plugin
	@if ! asdf plugin list 2>/dev/null | grep -q "^$(1)$$"; then \
		echo "$(YELLOW)Adding $(1) plugin...$(RESET)"; \
		if [ -n "$(strip $(2))" ]; then \
			asdf plugin add $(1) $(2) 2>/dev/null || { echo "$(RED)✗ Failed to add $(1) plugin$(RESET)"; exit 1; }; \
		else \
			asdf plugin add $(1) 2>/dev/null || { echo "$(RED)✗ Failed to add $(1) plugin$(RESET)"; exit 1; }; \
		fi; \
	fi
endef

# Generic tool installation function
define install_tool
	$(call check_asdf)
	$(call install_plugin,$(1),$(or $(2),))
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
		if asdf install $(1) $$LATEST; then \
			echo "$(GREEN)✓ $(1) $$LATEST installed$(RESET)"; \
		else \
			echo "$(RED)✗ Installation failed for $(1) $$LATEST$(RESET)"; \
			exit 1; \
		fi; \
	fi; \
	echo "  Setting $(1) $$LATEST as default..."; \
	asdf set --home $(1) $$LATEST; \
	asdf reshim $(1) 2>/dev/null
endef

# =============================================================================
# Help Target
# =============================================================================
help: ## Show this help message
	@echo ""
	@echo "$(BOLD)Dotfiles Makefile - macOS$(RESET)"
	@echo ""
	@echo "$(BOLD)Main Targets:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(all|brew|asdf|kitty|profile|tools|clean):' | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)  %-28s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)Profile Targets:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(zsh|neovim|tmux|git):' | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)  %-28s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)Tool Targets:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(brew-tools|nodejs|golang|terraform|kubernetes|list|update):' | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)  %-28s$(RESET) %s\n", $$1, $$2}'
	@echo ""

# =============================================================================
# Main Installation Targets
# =============================================================================
all: brew asdf profile tools kitty ## Install all components (full setup)
	@echo ""
	@echo "$(GREEN)$(BOLD)✓ Full installation complete!$(RESET)"
	@echo ""
	@echo "$(YELLOW)Next steps:$(RESET)"
	@echo "  1. Restart your terminal or run: source ~/.zshrc"
	@echo "  2. Open Kitty terminal for the full experience"
	@echo "  3. Run 'nvim' to complete plugin installation"
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
	else \
		ASDF_VERSION=$$(brew list --versions asdf | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'); \
		echo "$(GREEN)✓ ASDF v$$ASDF_VERSION already installed$(RESET)"; \
		echo "Location: $$(brew --prefix asdf)"; \
	fi
	@echo ""
	@echo "$(BOLD)Verifying ASDF installation...$(RESET)"
	@if command -v asdf >/dev/null 2>&1; then \
		echo "$(GREEN)✓ ASDF is active: $$(asdf --version | head -1)$(RESET)"; \
	else \
		echo "$(YELLOW)⚠ ASDF installed but not yet in PATH$(RESET)"; \
		echo "  Run: source ~/.zshrc"; \
	fi

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
	@if [ ! -f "$(DOTFILES)/kitty.conf" ]; then \
		echo "$(RED)✗ kitty.conf not found at $(DOTFILES)/kitty.conf$(RESET)"; \
		exit 1; \
	fi
	@mkdir -p $(KITTY_CONFIG)
	@if [ -f "$(KITTY_CONFIG)/kitty.conf" ] && [ ! -L "$(KITTY_CONFIG)/kitty.conf" ]; then \
		echo "$(YELLOW)Backing up existing kitty.conf to kitty.conf.backup$(RESET)"; \
		mv $(KITTY_CONFIG)/kitty.conf $(KITTY_CONFIG)/kitty.conf.backup; \
	fi
	@ln -sf $(DOTFILES)/kitty.conf $(KITTY_CONFIG)/kitty.conf
	@echo "$(GREEN)✓ Kitty configuration linked$(RESET)"
	@echo "  ~/.config/kitty/kitty.conf → $(DOTFILES)/kitty.conf"
	@echo ""
	@echo "$(GREEN)$(BOLD)✓ Kitty setup complete!$(RESET)"

clean: ## Remove symbolic links and temporary files
	@echo "$(BOLD)Cleaning up...$(RESET)"
	@echo "$(YELLOW)This will remove symlinked configurations$(RESET)"
	@rm -f $(KITTY_CONFIG)/kitty.conf
	@rm -f $(HOME)/.zshrc
	@rm -rf $(HOME)/.zsh.d
	@rm -rf $(HOME)/.config/nvim
	@rm -f $(HOME)/.tmux.conf
	@rm -f $(HOME)/.gitignore_global
	@echo "$(GREEN)✓ Cleanup complete$(RESET)"

# =============================================================================
# Profile Configuration Targets
# =============================================================================
profile: zsh neovim tmux git ## Install all profile configurations (ZSH, Neovim, Tmux, Git)
	@echo ""
	@echo "$(GREEN)$(BOLD)✓ Profile configuration complete!$(RESET)"
	@echo ""
	@echo "$(YELLOW)Next steps:$(RESET)"
	@echo "  1. Restart your terminal or run: source ~/.zshrc"
	@echo "  2. Run 'nvim' to install plugins automatically"
	@echo ""

zsh: ## Install ZSH configuration (Zinit + Powerlevel10k)
	@echo "$(BOLD)Installing ZSH configuration...$(RESET)"
	@if [ ! -f "$(DOTFILES)/zshrc" ]; then \
		echo "$(RED)✗ zshrc not found at $(DOTFILES)/zshrc$(RESET)"; \
		exit 1; \
	fi
	@if [ ! -d "$(DOTFILES)/zsh.d" ]; then \
		echo "$(RED)✗ zsh.d directory not found at $(DOTFILES)/zsh.d$(RESET)"; \
		exit 1; \
	fi
	@if [ -f "$(HOME)/.zshrc" ] && [ ! -L "$(HOME)/.zshrc" ]; then \
		echo "$(YELLOW)Backing up existing .zshrc to .zshrc.backup$(RESET)"; \
		mv $(HOME)/.zshrc $(HOME)/.zshrc.backup; \
	fi
	@if [ -d "$(HOME)/.zsh.d" ] && [ ! -L "$(HOME)/.zsh.d" ]; then \
		echo "$(YELLOW)Backing up existing .zsh.d to .zsh.d.backup$(RESET)"; \
		mv $(HOME)/.zsh.d $(HOME)/.zsh.d.backup; \
	fi
	@ln -sf $(DOTFILES)/zshrc $(HOME)/.zshrc
	@ln -sf $(DOTFILES)/zsh.d $(HOME)/.zsh.d
	@echo "$(GREEN)✓ ZSH configuration installed$(RESET)"
	@echo "  ~/.zshrc → $(DOTFILES)/zshrc"
	@echo "  ~/.zsh.d → $(DOTFILES)/zsh.d"

neovim: ## Install Neovim configuration (lazy.nvim + LSP)
	@echo "$(BOLD)Installing Neovim configuration...$(RESET)"
	@if [ ! -d "$(DOTFILES)/nvim" ]; then \
		echo "$(RED)✗ nvim directory not found at $(DOTFILES)/nvim$(RESET)"; \
		exit 1; \
	fi
	@mkdir -p $(CONFIG_DIR)
	@if [ -d "$(CONFIG_DIR)/nvim" ] && [ ! -L "$(CONFIG_DIR)/nvim" ]; then \
		echo "$(YELLOW)Backing up existing nvim config to nvim.backup$(RESET)"; \
		mv $(CONFIG_DIR)/nvim $(CONFIG_DIR)/nvim.backup; \
	fi
	@rm -rf $(CONFIG_DIR)/nvim
	@ln -sf $(DOTFILES)/nvim $(CONFIG_DIR)/nvim
	@echo "$(GREEN)✓ Neovim configuration installed$(RESET)"
	@echo "  ~/.config/nvim → $(DOTFILES)/nvim"
	@echo "$(YELLOW)  Run 'nvim' to install plugins automatically$(RESET)"

tmux: ## Install Tmux configuration (gpakosz/.tmux base)
	@echo "$(BOLD)Installing Tmux configuration...$(RESET)"
	@if [ ! -f "$(DOTFILES)/tmux.conf" ]; then \
		echo "$(RED)✗ tmux.conf not found at $(DOTFILES)/tmux.conf$(RESET)"; \
		exit 1; \
	fi
	@if [ -f "$(HOME)/.tmux.conf" ] && [ ! -L "$(HOME)/.tmux.conf" ]; then \
		echo "$(YELLOW)Backing up existing .tmux.conf to .tmux.conf.backup$(RESET)"; \
		mv $(HOME)/.tmux.conf $(HOME)/.tmux.conf.backup; \
	fi
	@ln -sf $(DOTFILES)/tmux.conf $(HOME)/.tmux.conf
	@echo "$(GREEN)✓ Tmux configuration installed$(RESET)"
	@echo "  ~/.tmux.conf → $(DOTFILES)/tmux.conf"

git: ## Install Git configuration (gitignore_global)
	@echo "$(BOLD)Installing Git configuration...$(RESET)"
	@if [ ! -f "$(DOTFILES)/gitignore_global" ]; then \
		echo "$(RED)✗ gitignore_global not found at $(DOTFILES)/gitignore_global$(RESET)"; \
		exit 1; \
	fi
	@if [ -f "$(HOME)/.gitignore_global" ] && [ ! -L "$(HOME)/.gitignore_global" ]; then \
		echo "$(YELLOW)Backing up existing .gitignore_global to .gitignore_global.backup$(RESET)"; \
		mv $(HOME)/.gitignore_global $(HOME)/.gitignore_global.backup; \
	fi
	@ln -sf $(DOTFILES)/gitignore_global $(HOME)/.gitignore_global
	@git config --global core.excludesfile $(HOME)/.gitignore_global 2>/dev/null || true
	@echo "$(GREEN)✓ Git configuration installed$(RESET)"
	@echo "  ~/.gitignore_global → $(DOTFILES)/gitignore_global"
	@echo "$(YELLOW)  Note: Set your name/email in ~/.gitconfig.local if needed$(RESET)"

# =============================================================================
# Development Tools Targets (ASDF + Homebrew)
# =============================================================================
tools: brew-tools nodejs golang terraform kubernetes ## Install essential development tools
	@echo ""
	@echo "$(GREEN)$(BOLD)✓ Essential development tools installed!$(RESET)"
	@echo ""
	@echo "$(YELLOW)Installed tools:$(RESET)"
	@asdf current 2>/dev/null | tail -n +2 | awk '{if($$2!="______") printf "  • %-12s %s\n", $$1, $$2}' || echo "  No ASDF tools installed yet"
	@echo ""

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

nodejs: ## Install Node.js (latest stable)
	$(call install_tool,nodejs,)

golang: ## Install Go (latest stable)
	$(call install_tool,golang,)

ruby: ## Install Ruby (latest stable)
	$(call install_tool,ruby,)

terraform: ## Install Terraform (latest stable)
	$(call install_tool,terraform,)

kubectl: ## Install kubectl (latest stable)
	$(call install_tool,kubectl,)

helm: ## Install Helm (latest stable)
	$(call install_tool,helm,)

kind: ## Install kind - Kubernetes in Docker
	$(call install_tool,kind,https://github.com/reegnz/asdf-kind.git)

kubectx: ## Install kubectx/kubens
	$(call install_tool,kubectx,https://github.com/virtualstaticvoid/asdf-kubectx.git)

kubernetes: kubectl helm kind kubectx ## Install all Kubernetes tools

docker: ## Install Docker Desktop via Homebrew
	@echo "$(BOLD)Installing Docker Desktop...$(RESET)"
	@if brew list --cask docker &>/dev/null; then \
		echo "$(GREEN)✓ Docker Desktop already installed$(RESET)"; \
	else \
		brew install --cask docker; \
		echo "$(GREEN)✓ Docker Desktop installed$(RESET)"; \
	fi

aws: ## Install AWS CLI
	$(call install_tool,awscli,)

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
