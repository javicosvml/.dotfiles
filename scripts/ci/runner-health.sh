#!/bin/bash
# GitHub Actions Runner Health Monitor
# Purpose: Monitor self-hosted macOS runner health
# Usage: ./scripts/ci/runner-health.sh

set -e

echo "GitHub Actions Runner Health Monitor"
echo "===================================="
echo ""

# 1. Runner Process Status
echo "1. Runner Process Status"
if pgrep -l "actions" > /dev/null; then
  echo "✅ Runner process running"
else
  echo "❌ Runner process NOT running"
  echo "   To start: launchctl start actions.runner"
fi
echo ""

# 2. Launchd Service Status
echo "2. Launchd Service Status"
launchctl list | grep -i actions || echo "⚠️  No actions runner service found"
echo ""

# 3. Disk Space
echo "3. Disk Space"
df -h / | tail -1

used_percent=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$used_percent" -gt 80 ]; then
  echo "⚠️  Warning: Disk usage high ($used_percent%)"
elif [ "$used_percent" -gt 90 ]; then
  echo "❌ Critical: Disk usage critical ($used_percent%)"
  exit 1
else
  echo "✅ Disk usage normal ($used_percent%)"
fi
echo ""

# 4. Memory Status
echo "4. Memory Status"
vm_stat | head -3
echo ""

# 5. Network Connectivity
echo "5. Network Connectivity"
if ping -c 1 api.github.com > /dev/null 2>&1; then
  echo "✅ Can reach GitHub API"
else
  echo "❌ Cannot reach GitHub API"
fi
echo ""

# 6. Software Versions
echo "6. Software Versions"
echo "  macOS: $(sw_vers -productVersion)"
[ -x "$(command -v node)" ] && echo "  Node: $(node --version)"
[ -x "$(command -v ruby)" ] && echo "  Ruby: $(ruby --version)"
echo ""

echo "Health check complete"
