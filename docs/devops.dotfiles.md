# DevOps & CI/CD

**Stack:** GitHub Actions · GitHub-hosted runners · macOS + Ubuntu  
**GitHub Tier:** Free  

---

## Workflows

Tres workflows, cada uno con un propósito distinto:

| Workflow | Runner | Trigger | Duration |
|----------|--------|---------|-----------------|
| `validate.yml` | `ubuntu-latest` | push to develop, PR to main/develop | ~2 min |
| `validate-macos.yml` | `macos-latest` | push to develop, PR to main | ~5-8 min |
| `security.yml` | `ubuntu-latest` | push to main/develop, PR to main/develop, weekly | ~4 min |

---

## validate.yml — Linting rápido (Ubuntu)

Validaciones baratas que no necesitan macOS real:

- **ShellCheck** — análisis estático de `scripts/`
- **ZSH syntax** — `zsh -n` en `zshrc` y todos los módulos de `zsh.d/`
- **TMUX syntax** — `tmux source-file tmux.conf`
- **Markdownlint** — formato de todos los `*.md`

---

## validate-macos.yml — Validación completa del stack (macOS)

Runner **GitHub-hosted `macos-latest`** — on-demand nativo, sin setup manual.

Un único job `validate` con estos steps:

| Step | What it does |
|------|----------|
| Install tools | `brew install tmux neovim kitty` + mise via curl |
| Symlink configs | Symlinks to `$GITHUB_WORKSPACE` (no `make profile`, avoids install-tpm side-effects) |
| **[ZSH]** Syntax | `zsh -n` en zshrc + 11 módulos de `zsh.d/` |
| **[ZSH]** Startup time | Pre-instala zinit → 3 runs de `zsh -i -c exit`, threshold 500ms |
| **[TMUX]** Validate | `tmux source-file ~/.tmux.conf` |
| **[Kitty]** Validate | `kitty --check-config` (graceful si no hay GPU/display) |
| **[Nvim]** Validate | `nvim --headless +qa` — config Lua sin descargar plugins |
| **[Mise]** Validate | `mise --version && mise doctor` |
| Step Summary | Tabla de resultados en GitHub Actions |

En PRs: comenta automáticamente los tiempos de startup de ZSH.

---

## security.yml — Seguridad (Ubuntu)

- **Gitleaks** — full git history scan for leaked secrets
- **Trivy** — detecta misconfiguraciones de seguridad, sube SARIF al Security tab

---

## Gitflow

```text
main (stable)
  ↑ PR requerido — todos los workflows deben pasar
  ├─ validate.yml          (shellcheck, zsh syntax, markdownlint)
  ├─ validate-macos.yml    (ZSH, TMUX, Kitty, Nvim, Mise)
  └─ security.yml          (gitleaks, trivy)

develop (integración)
  ↑ workflows para feedback
  └─ validate.yml + validate-macos.yml

feature/* (trabajo)
  └─ pre-commit hooks locales únicamente
```

---

## Branch protection

Configurar en **Settings → Branches → Branch protection rules** para `main`:

```text
Require status checks to pass before merging:
  ✓ Validate (ubuntu)
  ✓ macOS Config Validation
  ✓ Secret Scan (Gitleaks)
Require branches to be up to date: YES
Restrict force pushes: YES
```

---

## Troubleshooting local

Si los workflows fallan, reproducir localmente:

```bash
# Validar sintaxis
bash scripts/validate-configs.sh

# ZSH módulos
for f in zsh.d/*.zsh; do zsh -n "$f"; done

# TMUX
tmux source-file ~/.tmux.conf

# Startup time
for i in 1 2 3; do time zsh -i -c exit; done

# Verificar prereqs
make verify
```

**ZSH startup > 500ms:**

```bash
# Perfilar módulo a módulo
for f in ~/.zsh.d/*.zsh; do
  echo "=== $(basename $f) ===" && time zsh -n "$f"
done
```

---

## FAQ

**¿Costo del runner macOS?**  
Cero. GitHub-hosted `macos-latest` en free tier usa el multiplicador de 10x minutos. Con ~200 minutos macOS/mes disponibles, una run de ~6 min deja margen para ~30 runs mensuales.

**¿Necesito configurar el runner?**  
No. GitHub lo levanta automáticamente en cada workflow run. No hay scripts, LaunchD, ni tokens que gestionar.

**¿Puedo desarrollar offline?**  
Sí. Los workflows no corren, pero puedes validar todo localmente con `bash scripts/validate-configs.sh` y `make verify`.

**¿Qué versión de macOS usa el runner?**  
`macos-latest` apunta a la última versión estable disponible en GitHub (actualmente macOS 15 Sequoia, Apple Silicon M-series).
