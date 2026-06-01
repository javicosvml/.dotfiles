# DevOps & CI/CD Setup for .dotfiles (June 2026)

**Last Updated:** June 1, 2026  
**Status:** Production Ready  
**GitHub Tier:** Free  

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Self-Hosted macOS Runner Setup (On-Demand)](#self-hosted-macos-runner-setup-on-demand)
3. [GitHub Actions Workflows](#github-actions-workflows)
4. [Branch Protection & Gitflow](#branch-protection--gitflow)
5. [Monitoring & Troubleshooting](#monitoring--troubleshooting)
6. [Performance Metrics](#performance-metrics)
7. [FAQ](#faq)

---

## Quick Start

### For New Users

You don't need to do anything. The CI/CD is already configured. When you create a PR:

- PR to develop → Ubuntu validation (2 min) → Status checks pass
- PR to main → macOS validation (8 min) → Security scan → Ready to merge

### For Developers Modifying Config

```bash
# 1. Create feature branch
git checkout -b feature/your-change

# 2. Make changes and commit
git commit -m "feat: add something"

# 3. Push and create PR to develop
git push origin feature/your-change

# 4. CI/CD automatically validates
# → Ubuntu: fast syntax check
# → macOS: comprehensive setup validation
# → Security: secret scanning + config audit

# 5. Merge to develop when approved
# 6. Create PR to main for release
# → All workflows run again (gating before main merge)
```

---

## Self-Hosted macOS Runner Setup (On-Demand)

### Runner Model: On-Demand

This project uses **on-demand self-hosted runners**, not always-on:

- **Free:** No GitHub Actions minute cost
- **On-demand:** Start manually when needed (not 24/7)
- **Accurate:** Tests actual macOS, not simulated
- **Control:** Full manual control over when runner is active
- **Realistic:** Perfect for personal .dotfiles (no need for always-on)

### Typical Workflow

```bash
# Step 1: Prepare changes in develop
git checkout -b feature/something
# ... make changes ...
git push origin feature/something

# Step 2: Start runner (one-time before PR)
cd ~/actions-runner
./run.sh
# Output: "Listening for Jobs"

# Step 3: Create PR to main (in browser or via GitHub CLI)
# Ubuntu validation starts automatically

# Step 4: macOS validation waits for your runner
# Your terminal shows jobs executing in real-time

# Step 5: When done, stop runner
Ctrl+C

# Step 6: Merge PR if all green
```

### Prerequisites

Before setting up, ensure you have:

```bash
# Check all prerequisites
make verify

# Or manually:
sw_vers -productVersion        # macOS version
xcode-select --version          # Xcode CLT
brew --version                  # Homebrew
mise --version || asdf version  # Version manager
```

### Step 1: Register Runner on GitHub

1. Go to **Repository Settings** → **Actions** → **Runners**
2. Click **New self-hosted runner**
3. Choose: OS: macOS, Architecture: x64
4. Follow GitHub's instructions to download and run config.sh:

```bash
./config.sh --url https://github.com/USERNAME/.dotfiles \
            --token YOUR_REGISTRATION_TOKEN

# Answer prompts:
# Labels: self-hosted,macos,ventura
# Work directory: _work (default OK)
# Run as service: yes
```

### Step 2: Configure Launchd Agent (Auto-Start)

```bash
# From the runner directory:
./svc.sh install

# Verify it's running:
launchctl list | grep actions

# Logs:
log stream --predicate 'process == "runsvc"' --level debug
```

### Step 3: Verify Runner Online

```bash
# In terminal
./run.sh

# Expected output:
# Waiting for message...
# Current runner version: ...
# Listening for Jobs

# In GitHub: Settings → Actions → Runners
# Status should show "Idle" (green dot)
```

### Step 4: Test Workflow

Push a test PR:

```bash
git checkout -b test/runner-validation
echo "# Test" >> README.md
git add README.md && git commit -m "test: ci/cd"
git push origin test/runner-validation
```

Watch Actions tab:
1. validate.yml runs (2 min)
2. validate-macos.yml triggers (8 min)
3. All jobs complete with green checkmarks

Then delete the branch:

```bash
git push origin --delete test/runner-validation
```

---

## GitHub Actions Workflows

### Workflow: validate.yml (Ubuntu, ~2 min)

**Triggers:** PR to main/develop, push to develop

**Jobs:**
- shellcheck: Shell script validation
- validate-configs: ZSH/Tmux syntax
- markdownlint: Markdown formatting

**Catches:** Shell syntax, config formatting, markdown issues

### Workflow: validate-macos.yml (Self-Hosted macOS, ~8 min)

**Triggers:** PR to main, push to develop

**Jobs:**
- system-requirements: macOS, Xcode, Homebrew (20 sec)
- make-verify: Check prerequisites (30 sec)
- make-profile: Test symlink creation (1 min)
- config-validation: Validate ZSH modules (30 sec)
- zsh-startup-time: Measure performance (10 sec)
- integration-test: Test tool availability (1 min)
- runner-health: Monitor resources (always runs)

**Catches:** macOS incompatibility, missing tools, symlink failures, perf regressions, tool issues

### Workflow: security.yml (Ubuntu, ~4 min)

**Triggers:** PR to main/develop, weekly scheduled

**Jobs:**
- gitleaks: Secret detection
- trivy: Configuration vulnerabilities

**Catches:** Leaked AWS keys, tokens, security misconfigurations

---

## Branch Protection & Gitflow

### Gitflow Overview

```
main (stable)
  ↑ PR required, all workflows must pass
  ├─ validate.yml
  ├─ validate-macos.yml (CRITICAL)
  └─ security.yml

develop (integration)
  ↑ PR optional
  └─ workflows for feedback

feature/* (feature branches)
  └─ Local pre-commit only
```

### Branch Protection Rules for main

```
Require status checks to pass:
  - Validate
  - Validate on macOS (CRITICAL)
  - Security

Require branches up to date: YES
Restrict force pushes: YES
```

**Setup:**
1. Settings → Branches → Add branch protection rule
2. Check: Require status checks, require branches up to date
3. Select the 3 workflows above

---

## Monitoring & Troubleshooting

### Manual Runner Check

```bash
# Verify running
launchctl list | grep actions

# Check disk space
df -h /

# Check memory
vm_stat
```

### Common Issues

**Runner Offline:**

```bash
launchctl stop actions.runner
sleep 5
launchctl start actions.runner
```

**Workflow Timeout:**

```bash
# Check system resources
df -h /              # Disk space?
vm_stat              # Memory?

# Kill stale processes
pkill -f "actions-runner"
sleep 5
launchctl start actions.runner
```

**Startup Time > 500ms:**

Profile the startup:

```bash
time zsh -i -c exit

# Or detailed:
zsh -x -i -c exit 2>&1 | head -50

# Check each module:
for f in ~/.zsh.d/*.zsh; do
  echo "=== $(basename $f) ==="
  time zsh -n $f
done
```

Fix: Optimize slowest module or move expensive operations to lazy-load.

---

## Performance Metrics

### Tracking Startup Time

Workflow automatically reports:

```
📊 Startup Time Statistics:
  Mean: 120ms
  Min: 115ms
  Max: 130ms
✅ Startup time within threshold
```

### Alerts

Alerts if startup:
- Exceeds 500ms threshold
- Shows >10% regression from baseline

Action: Review recent zsh.d/ changes and optimize.

---

## FAQ

### Q: Can I skip macOS validation for urgent fixes?

A: No. Branch protection requires all checks before main merge. To workaround:

```bash
launchctl start actions.runner
# Wait 1 min for online status
# Re-run workflow in GitHub
```

### Q: What's the cost?

A: Free. Self-hosted runner on your Mac costs nothing.

### Q: Can I run multiple runners?

A: Yes, but not needed for personal use. Each registers separately with unique name.

### Q: How often do I need to maintain the runner?

A: Monthly health checks (~30 min):
- Verify online status
- Check disk space
- Monitor memory
- Review workflow logs

### Q: Can I disable startup time tracking?

A: Yes. Comment out zsh-startup-time job in validate-macos.yml. Other jobs run independently.

### Q: What if I need offline development?

A: Workflows won't run. Run validations locally:

```bash
bash scripts/validate-configs.sh
zsh -n zsh.d/*.zsh
make verify
make profile
```

---

## Integration with OpenCode (@dot)

Workflows align with @dot agent validation:

```
@dot validate-macos checks:
├─ System requirements
├─ make verify
├─ Symlinks
├─ Config syntax
├─ Startup performance
└─ Tool integration

Usage:
  @dot run full validation locally
  @dot check startup regression
  @dot diagnose symlink failures
```

---

## Next Steps

1. Setup runner: Self-Hosted macOS Runner Setup section
2. Configure branch protection on main
3. Test: Push a PR and watch workflows
4. Monitor: Check runner health monthly

---

Questions? Review GitHub Actions workflow files or see .opencode/README.md for agent integration.
