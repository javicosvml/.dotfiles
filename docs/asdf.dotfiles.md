# ASDF Version Manager

ASDF is installed via Homebrew and initialized in `zsh.d/tools.zsh`. Used for Node.js, Go, Ruby, Terraform, and all Kubernetes CLI tools.

## Initialization (tools.zsh)

ASDF init follows a priority chain:

1. Homebrew path: `$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh`
2. Fallback: `$HOME/.asdf/asdf.sh`

Completions are loaded from `$HOMEBREW_PREFIX/opt/asdf/share/zsh/site-functions` or `$ASDF_DIR/completions`.

## Managed Tools

| Tool | Installed via | Notes |
|------|--------------|-------|
| Node.js | `make nodejs` | LTS only (even major: 20, 22, 24…) |
| Go | `make golang` | Latest stable |
| Ruby | `make ruby` | Latest stable |
| Terraform | `make terraform` | Latest stable |
| kubectl | `make kubectl` | Latest stable |
| Helm | `make helm` | Latest stable |
| kind | `make kind` | Custom ASDF plugin |
| kubectx | `make kubectx` | Custom ASDF plugin |
| AWS CLI | `make aws` | Latest stable |

## Common Commands

```bash
asdf current              # show active version for all tools
asdf list nodejs          # list installed Node.js versions
asdf latest nodejs        # show latest available version
asdf install nodejs 22.x  # install specific version
asdf set --home nodejs 22.x  # set global default
asdf reshim nodejs        # rebuild shims after install
asdf plugin update --all  # update all plugins
```

## Node.js LTS Detection

`make nodejs` filters for even major versions:

```bash
asdf list all nodejs | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' \
  | while read v; do
      MAJOR=$(echo $v | cut -d. -f1)
      if (( MAJOR % 2 == 0 )); then echo $v; fi
    done | sort -V | tail -1
```

`make nodejs-update` compares current vs latest LTS and only installs if a newer version is available.

## Update ASDF

```bash
make update    # brew upgrade asdf + asdf plugin update --all
```
