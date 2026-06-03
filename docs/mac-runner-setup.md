# Self-Hosted macOS Runner Setup Guide

**Status:** Quick Reference  
**Last Updated:** June 3, 2026  
**Runner Model:** On-Demand (manual start/stop, not always-on)

---

## Quick Start (On-Demand Model)

**Recommended Workflow:**

```bash
# Terminal 1: Start runner (stays running until Ctrl+C)
./scripts/ci/runner.sh start

# Terminal 2: Create PR (triggers workflows automatically)
git checkout -b feature/xyz
git add .
git commit -m "feat: xyz"
git push origin feature/xyz
# Create PR on GitHub → Watch Actions tab

# Terminal 1: Stop runner (Ctrl+C)
```

---

## Prerequisites

Before starting, verify:

```bash
# Check all prerequisites
make verify

# Individual checks:
sw_vers -productVersion        # macOS 12.0+
xcode-select --version         # Xcode CLT installed
brew --version                 # Homebrew installed
mise --version || asdf version # Version manager
df -h /                        # At least 5GB free
```

---

## Step 1: Download GitHub Actions Runner

1. Go to: **GitHub Repo Settings** → **Actions** → **Runners**
2. Click: **New self-hosted runner**
3. Select:
   - **OS:** macOS
   - **Architecture:** x64 (or ARM64 if Apple Silicon)
4. GitHub will show download link and instructions

Or manually:

```bash
# Go to Actions/Runners page, copy the download URL
# Then:
cd ~
mkdir -p actions-runner
cd actions-runner

# Download latest release
# (GitHub shows specific version on settings page)
curl -O -L https://github.com/actions/runner/releases/download/v2.x.x/actions-runner-osx-x64-2.x.x.tar.gz

# Extract
tar xzf actions-runner-osx-x64-2.x.x.tar.gz
```

---

## Step 2: Configure Runner

```bash
cd ~/actions-runner

# Run configuration script
./config.sh

# When prompted:
# URL: https://github.com/USERNAME/.dotfiles
# Token: (From GitHub Settings page)
# Name: (optional, e.g. "macOS-Ventura")
# Labels: self-hosted,macos,ventura
# Work directory: _work (press Enter for default)
# Run as service: Yes
```

---

## Step 3: Using the On-Demand Runner

**Preferred Method: Use runner.sh Script**

```bash
# Start runner (foreground, easy to stop with Ctrl+C)
./scripts/ci/runner.sh start

# Check status
./scripts/ci/runner.sh status

# Stop runner (manual or Ctrl+C)
./scripts/ci/runner.sh stop

# Get help
./scripts/ci/runner.sh help
```

**Alternative: Manual Run**

```bash
cd ~/actions-runner

# Run in foreground
./run.sh

# Expected output:
# ✓ Listening for Jobs
# (Press Ctrl+C to stop)
```

---

## Step 4: Test Workflow

Create and test a PR:

```bash
# Terminal 1: Start runner
./scripts/ci/runner.sh start

# Terminal 2: Create test PR
git checkout -b test/ci-validation
echo "# Test CI" >> README.md
git add README.md
git commit -m "test: validate CI/CD workflow"
git push origin test/ci-validation
```

Then:

1. Create PR on GitHub (to develop or main branch)
2. Go to **Actions** tab in GitHub
3. Watch workflows execute on self-hosted runner
4. Verify all jobs pass:
   - system-requirements (~30s)
   - make-verify (~1m)
   - make-profile (~1m)
   - config-validation (~30s)
   - zsh-startup-time (~1m)
   - integration-test (~30s)
   - runner-health (~30s)
   - Total: ~3.5-4 min per workflow run

Clean up test branch:

```bash
# Terminal 2: After PR is closed/merged
git checkout develop
git branch -D test/ci-validation
git push origin --delete test/ci-validation

# Terminal 1: Stop runner
# (Press Ctrl+C)
```

---

## Step 5: Alternative Setup - Always-On Service (Optional)

If you prefer always-on operation (not recommended for personal use):

```bash
cd ~/actions-runner

# Install as LaunchD service
./svc.sh install

# Verify it's running
launchctl list | grep actions.runner

# Start/stop as needed
launchctl start actions.runner
launchctl stop actions.runner
```

**Note:** On-demand (Step 3) is recommended for personal repos to save resources.

---

## Common Commands

**Using runner.sh (Recommended):**

```bash
# Start on-demand runner
./scripts/ci/runner.sh start

# Check if running
./scripts/ci/runner.sh status

# Stop runner
./scripts/ci/runner.sh stop

# Configure runner
./scripts/ci/runner.sh config
```

**Manual Runner Commands (Alternative):**

```bash
# Start runner manually
cd ~/actions-runner
./run.sh

# Stop runner (from different terminal)
pkill -f "Runner.Listener"

# Check runner directory
cd ~/actions-runner
ls -la
```

**LaunchD Service Commands (If using always-on mode):**

```bash
# Start service
launchctl start actions.runner

# Stop service
launchctl stop actions.runner

# Check status
launchctl list | grep actions.runner

# View logs
log stream --predicate 'process == "runner"' --level debug
```

---

## Troubleshooting

### Runner Won't Start

```bash
# Check config
cat ~/.runner

# Reconfigure
./config.sh --uninstall
./config.sh --url https://github.com/USERNAME/.dotfiles \
            --token NEW_TOKEN
./svc.sh install
```

### Disk Space Issues

```bash
df -h /

# If < 2GB:
brew cleanup -s
rm -rf ~/.cache/*
rm -rf ~/actions-runner/_work/*
```

### Runner Goes Offline After Reboot

```bash
# Verify launchd service
launchctl list | grep actions.runner

# If missing, reinstall
cd ~/actions-runner
./svc.sh install

# Or enable for auto-start
launchctl start actions.runner
```

---

## Auto-Start After Mac Reboot

Launchd agent should handle this automatically. Verify:

```bash
# Check if agent is loaded
launchctl list | grep actions.runner

# If not present, reinstall service
cd ~/actions-runner
./svc.sh install
```

---

## Next Steps

1. **Runner is configured** ✅
2. **Start runner when needed:**
   ```bash
   ./scripts/ci/runner.sh start
   ```
3. **Create PR to trigger workflows** (runner must be running)
4. **Stop runner when done** (Ctrl+C or `./scripts/ci/runner.sh stop`)
5. **Monitor health monthly:**
   ```bash
   ./scripts/ci/runner-health.sh
   ```

**Typical Workflow:**
- Morning: Start runner with `./scripts/ci/runner.sh start`
- Work: Make commits, create PRs, workflows run automatically
- Evening: Stop runner with Ctrl+C
- Repeat as needed

---

## FAQ

**Q: Do I need to start the runner manually every time?**  
A: Yes, on-demand model. Use `./scripts/ci/runner.sh start`. Press Ctrl+C to stop when done.

**Q: What if I want always-on (auto-start after reboot)?**  
A: Possible but not recommended for personal use. See Step 5 for LaunchD setup.

**Q: Can I have multiple runners?**  
A: Yes, register separately with different names/labels.

**Q: How much disk space does runner need?**  
A: ~5GB initial, grows with workflow artifacts. Clean with: `rm -rf ~/actions-runner/_work/*`

**Q: How do I uninstall the runner?**  
A:
```bash
cd ~/actions-runner
./svc.sh uninstall  # If using LaunchD service
rm -rf ~/actions-runner
```

**Q: Where are runner logs?**  
A: Check: `~/actions-runner/_diag/Worker_*.log`

**Q: Runner not appearing in GitHub?**  
A:
- Check: `./scripts/ci/runner.sh status`
- Verify: Network connectivity and repo access
- Reconfigure: `./scripts/ci/runner.sh config`

**Q: How often should I update the runner?**  
A: Check monthly for updates. GitHub auto-notifies of critical updates.
