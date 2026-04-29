# GitHub Repository Configuration — DevSecOps Reference

**Repository:** [javicosvml/.dotfiles](https://github.com/javicosvml/.dotfiles)
**Last Updated:** 2026-04-29
**Standard:** GitHub Free (public repo) + April 2026 best practices

---

## Repository Settings

| Setting | Value | Reason |
|---------|-------|--------|
| Visibility | Public | Required for free-tier branch rulesets, secret scanning, and Dependabot |
| Default branch | `main` | Stable, production-ready config |
| Merge strategy | Squash only | Clean linear history, each PR = one commit |
| Merge commit | Disabled | Prevents noisy merge commits |
| Rebase merge | Disabled | All history flows through squash for consistency |
| Delete branch on merge | Enabled | Automatic cleanup after PR merge |
| Squash commit title | PR title | Clear, scannable history |
| Squash commit body | PR body | Preserves context in git log |

---

## Branching Strategy

```
main ──────────────────────────────────────── production-ready
           ↑ squash PR
develop ───────────────────────────────────── integration branch
           ↑ squash PR
feature/* ─────────────────────────────────── short-lived work
fix/*     ─────────────────────────────────── bug fixes
chore/*   ─────────────────────────────────── maintenance
```

### Branch lifecycle

1. Branch from `develop`: `git checkout -b feat/my-change develop`
2. Work and commit locally with Conventional Commits format
3. Open PR → `develop` (triggers `validate.yml` + `security.yml`)
4. Squash-merge to `develop` after CI passes
5. Open PR → `main` from `develop` when a stable batch is ready
6. Squash-merge to `main`

### Branch naming conventions

| Prefix | Use for |
|--------|---------|
| `feat/` | New tools, plugins, configurations |
| `fix/` | Bug fixes, broken bindings, config corrections |
| `chore/` | Dependency updates, CI changes, cleanup |
| `docs/` | Documentation-only changes |
| `refactor/` | Restructure without functional change |

---

## Branch Rulesets

Rulesets are the modern GitHub standard (2024+), replacing legacy branch protection rules. They work on the **Free tier for public repos**.

### `protect-main` (ID: 15746366)

| Rule | Config |
|------|--------|
| Deletion | Blocked — `main` cannot be deleted |
| Non-fast-forward | Blocked — no force pushes |
| Pull request required | Yes — all changes via PR |
| Required reviews | 0 (solo repo) |
| Dismiss stale reviews | Yes |
| Resolve all threads | Required before merge |

### `protect-develop` (ID: 15746474)

| Rule | Config |
|------|--------|
| Deletion | Blocked |
| Non-fast-forward | Blocked — no force pushes |

> **Note on Free tier:** Required status checks in rulesets require GitHub Pro/Team for private repos, but work on public repos with GitHub Free. The current setup is optimally configured for this tier.

---

## GitHub Actions Workflows

All workflows pin Actions to **commit SHA** to prevent tag-mutation supply chain attacks.

### `validate.yml` — Code Quality

**Triggers:** Push to `develop`, PR to `main` or `develop`

| Job | Tool | What it checks |
|-----|------|----------------|
| `shellcheck` | ludeeus/action-shellcheck | Shell script correctness in `scripts/` |
| `validate-configs` | native zsh | ZSH module syntax, tmux.conf readability, zshrc syntax |
| `markdownlint` | DavidAnson/markdownlint-cli2 | Markdown quality across all `.md` files |

### `security.yml` — Security Scanning

**Triggers:** Push to `main`/`develop`, PR to `main`/`develop`, weekly Monday 08:00 UTC

| Job | Tool | What it checks |
|-----|------|----------------|
| `gitleaks` | gitleaks/gitleaks-action | Secrets, credentials, API keys in full git history |
| `trivy` | aquasecurity/trivy-action | Misconfiguration scan, results uploaded as SARIF to GitHub Security tab |

### Why weekly scheduled scans?

New secret patterns are added to Gitleaks and Trivy databases continuously. A weekly scan catches secrets committed months ago that weren't detected when the pattern didn't exist yet.

---

## Repository Security Features

Configured via API on 2026-04-29:

| Feature | Status | What it does |
|---------|--------|--------------|
| Secret scanning | Enabled | Scans commits for known secret patterns (GitHub native) |
| Secret scanning push protection | Enabled | Blocks pushes containing detected secrets before they land |
| Dependabot vulnerability alerts | Enabled | Alerts when a dependency has a known CVE |
| Dependabot automated security fixes | Enabled | Auto-opens PRs to fix vulnerable dependencies |

### Dependabot configuration (`.github/dependabot.yml`)

Scans `github-actions` ecosystem weekly on Mondays at 08:00 Europe/Madrid. Groups all Action updates into a single PR to reduce noise.

---

## Commit Convention

All commits follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

Co-Authored-By: Claude <noreply@anthropic.com>
```

| Type | Use when |
|------|----------|
| `feat` | Adding a new tool, plugin, or configuration |
| `fix` | Fixing a broken binding, alias, or setting |
| `docs` | Documentation changes only |
| `refactor` | Restructuring without functional change |
| `chore` | Dependencies, CI, file cleanup |
| `test` | Adding or updating validation scripts |

---

## CODEOWNERS

`.github/CODEOWNERS` assigns `@javicosvml` as the required reviewer for all files. For a solo repo this ensures GitHub's review flow works correctly when branch protection rules reference code owners.

---

## PR Template

`.github/pull_request_template.md` enforces a consistent checklist on every PR:

- Change summary
- Type classification (feat/fix/refactor/docs/chore)
- Validation checklist: `zsh -n`, `tmux source-file`, no secrets, `make verify`, `validate-configs.sh`

---

## Upgrade Path (if moving to GitHub Pro or Team)

The current setup is maximal for GitHub Free public repos. With Pro/Team, these additional protections become available:

| Feature | Requires | How to enable |
|---------|----------|---------------|
| Required status checks in rulesets | Pro/Team | Add `required_status_checks` rule to existing rulesets via API |
| Branch protection on private repos | Pro/Team | Move to rulesets on the private version |
| Required signed commits | Pro/Team | Add `commit_author_email_pattern` or `committer_email_pattern` rule |
| Deployment environments with approval gates | Pro/Team | Create environments via Settings → Environments |

```bash
# Add required status checks to protect-main (Pro/Team only)
gh api -X PUT repos/javicosvml/.dotfiles/rulesets/15746366 \
  --input - <<'EOF'
{
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    { "type": "pull_request", "parameters": { "required_approving_review_count": 0 } },
    { "type": "required_status_checks", "parameters": {
        "strict_required_status_checks_policy": true,
        "required_status_checks": [
          { "context": "Validate / ShellCheck" },
          { "context": "Validate / Validate Configs" },
          { "context": "Security / Secret Scan (Gitleaks)" }
        ]
    }}
  ]
}
EOF
```

---

## Maintenance

### Updating pinned Action SHAs

Dependabot handles this automatically via `.github/dependabot.yml`. Weekly PRs will update the pinned SHAs as upstream releases new versions.

To manually check current SHAs:

```bash
# Check latest SHA for an action
gh api repos/actions/checkout/git/refs/tags/v4 --jq '.object.sha'
```

### Re-running the security configuration

If the repo settings need to be re-applied from scratch:

```bash
# Merge strategy: squash-only
gh api -X PATCH /repos/javicosvml/.dotfiles \
  -f allow_merge_commit=false \
  -f allow_rebase_merge=false \
  -f allow_squash_merge=true \
  -f delete_branch_on_merge=true \
  -f squash_merge_commit_title=PR_TITLE \
  -f squash_merge_commit_message=PR_BODY

# Security features
gh api -X PUT repos/javicosvml/.dotfiles/vulnerability-alerts
gh api -X PUT repos/javicosvml/.dotfiles/automated-security-fixes
gh repo edit javicosvml/.dotfiles \
  --enable-secret-scanning \
  --enable-secret-scanning-push-protection
```

---

## References

- [GitHub Rulesets documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets)
- [Gitleaks](https://github.com/gitleaks/gitleaks)
- [Trivy](https://github.com/aquasecurity/trivy)
- [Dependabot configuration](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Pinning Actions to SHA](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#using-third-party-actions)
