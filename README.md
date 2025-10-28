# Dotfiles Repository

## Overview
Personal dotfiles repository for managing system configuration and tool installations on macOS.

## Prerequisites
- macOS
- Make
- ASDF version manager (installed by scripts)

## Quick Start

### Installation Commands
```bash
make help        # Show all available commands
make all         # Install everything (ZSH, Tmux, Neovim, tools)
make profile     # Install ZSH, Tmux, and Neovim profiles
make tools       # Install basic tools
make asdf        # Install/Reinstall ASDF version manager
```

## Repository Structure
- `Makefile`: Central installation and management script
- `scripts/`: Custom utility scripts
- `profile/`: Configuration for ZSH, Tmux, and Neovim
- `tools/`: Tool installation scripts

## Environment
- Targets macOS
- Uses ASDF for version management
- Supports custom installation workflows

## Contributing
- Always run `make help` to understand available commands
- Respect existing script and configuration patterns
- Test changes across different macOS environments