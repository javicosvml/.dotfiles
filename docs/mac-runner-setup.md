# Self-Hosted macOS Runner Setup Guide

**Status:** Quick Reference  
**Last Updated:** June 1, 2026  

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

## Step 3: Install as LaunchD Service (Auto-Start)

```bash
cd ~/actions-runner

# Install service
./svc.sh install

# Verify it's running
launchctl list | grep actions.runner

# Expected output:
# - PID number (running)
# OR
# - "load error" if not started yet

# Start service manually if needed
launchctl start actions.runner
```

---

## Step 4: Verify Online Status

Check in GitHub:

1. Go to: **Settings** → **Actions** → **Runners**
2. Look for your runner name
3. Status should show: **Idle** (green dot)
4. If offline, wait 1-2 minutes or restart

Or check locally:

```bash
# Terminal on your Mac
cd ~/actions-runner
./run.sh

# Expected output:
# ✓ Listening for Jobs
# (Wait here - ctrl+C to stop)

# In GitHub, check status updates
```

---

## Step 5: Test Workflow

Create test PR:

```bash
git checkout -b test/ci-validation
echo "# Test CI" >> README.md
git add README.md
git commit -m "test: validate CI/CD workflow"
git push origin test/ci-validation
```

Then:

1. Create PR on GitHub (to develop branch)
2. Go to **Actions** tab
3. Watch workflows execute
4. Verify all jobs pass:
   - validate.yml (Ubuntu, ~2 min)
   - Then validate-macos.yml (macOS, ~8 min)

Delete test branch when done:

```bash
git checkout develop
git branch -D test/ci-validation
git push origin --delete test/ci-validation
```

---

## Common Commands

```bash
# Check status
launchctl list | grep actions

# Start runner
launchctl start actions.runner

# Stop runner
launchctl stop actions.runner

# Restart runner
launchctl stop actions.runner
sleep 5
launchctl start actions.runner

# View logs
log stream --predicate 'process == "runner"' --level debug

# Check runner directory
cd ~/actions-runner
ls -la
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

1. Verify runner is **online** in GitHub
2. Test with sample PR
3. Monitor health monthly using: `./scripts/ci/runner-health.sh`
4. Keep runner running (always-on recommended)

---

## FAQ

**Q: Do I need to do anything after Mac restarts?**  
A: No. Launchd automatically restarts the service.

**Q: Can I run multiple runners?**  
A: Yes, register separately with different names/labels.

**Q: How much disk space does runner need?**  
A: ~5GB initial, grows with workflow artifacts.

**Q: Can I uninstall runner?**  
A: Yes - run `./svc.sh uninstall` then delete ~/actions-runner
