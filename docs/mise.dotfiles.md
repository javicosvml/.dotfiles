# mise Version Manager

mise is installed via Homebrew and activated in `zsh.d/tools.zsh`. Replaces ASDF as the development tool version manager. Reads `~/.tool-versions` natively (ASDF-compatible format) and supports `mise.toml` per-project overrides.

## Activation (tools.zsh)

```zsh
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi
```

This injects mise shims into the PATH and enables hook-based version switching.

## Managed Tools

| Tool | Makefile target | Notes |
|------|----------------|-------|
| Node.js | `make nodejs` | `node@lts` — latest active LTS |
| Go | `make golang` | Latest stable |
| Ruby | `make ruby` | Latest stable |
| Terraform | `make terraform` | Latest stable |
| kubectl | `make kubectl` | Latest stable |
| Helm | `make helm` | Latest stable |
| kind | `make kind` | Latest stable |
| AWS CLI | `make aws` | Latest stable |
| kubectx | `make kubectx` | Installed via Homebrew (no mise backend) |

## Common Commands

```bash
mise ls                        # list all tools with version and source
mise current                   # show active version for each tool
mise use --global node@lts     # install and set Node.js LTS as global default
mise use --global go@latest    # install and set Go latest as global default
mise install                   # install all versions declared in ~/.tool-versions
mise upgrade                   # upgrade all global tools to latest
mise upgrade node              # upgrade a specific tool
mise which node                # show path to active binary
```

## Global vs Project Versions

mise resolves versions in this priority order:

1. `mise.toml` in current directory or any parent
2. `.tool-versions` in current directory or any parent
3. `~/.config/mise/config.toml` (global config)
4. `~/.tool-versions` (global fallback — current setup)

To pin a tool version for a specific project:

```bash
cd ~/my-project
mise use node@20    # creates/updates .mise.toml in project root
```

## Migrating from ASDF

mise reads `~/.tool-versions` without conversion — all existing versions are picked up automatically. To install all declared tools in mise's own store:

```bash
mise install    # downloads and caches all versions from ~/.tool-versions
```

After verifying mise works, ASDF can be removed:

```bash
brew uninstall asdf
```

## Update mise

```bash
make update           # brew upgrade mise + mise upgrade (all tools)
brew upgrade mise     # mise binary only
```
