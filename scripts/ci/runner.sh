#!/bin/bash
# On-Demand Self-Hosted Runner Launcher
#
# Usage: ./scripts/ci/runner.sh [start|stop|status|config]
#
# This script manages the GitHub Actions self-hosted runner for on-demand use.
# Model: Start runner manually → Create PR → Workflows auto-trigger → Stop runner

set -euo pipefail

# Configuration
RUNNER_DIR="${HOME}/actions-runner"
REPO_URL="https://github.com/javicosvml/.dotfiles"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
  echo -e "${RED}❌ $1${NC}" >&2
}

log_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

check_prerequisites() {
  log_info "Checking prerequisites..."

  # Check if runner directory exists
  if [ ! -d "$RUNNER_DIR" ]; then
    log_error "Runner directory not found: $RUNNER_DIR"
    log_info "Please run: docs/mac-runner-setup.md (Step 1-2)"
    exit 1
  fi

  # Check if runner is configured
  if [ ! -f "$RUNNER_DIR/.runner" ]; then
    log_error "Runner not configured"
    log_info "Please run: $RUNNER_DIR/config.sh"
    exit 1
  fi

  log_success "Prerequisites check passed"
}

runner_status() {
  log_info "Checking runner status..."

  if [ -f "$RUNNER_DIR/.runner" ]; then
    if pgrep -f "Runner.Listener" > /dev/null; then
      log_success "Runner is RUNNING"
      ps aux | grep -i "Runner.Listener" | grep -v grep || true
      return 0
    else
      log_warning "Runner is STOPPED"
      return 1
    fi
  else
    log_error "Runner not configured"
    return 1
  fi
}

runner_start() {
  log_info "Starting on-demand runner..."

  check_prerequisites

  if pgrep -f "Runner.Listener" > /dev/null; then
    log_warning "Runner already running"
    return 0
  fi

  cd "$RUNNER_DIR"

  log_info "Launching runner in foreground..."
  log_info "Press Ctrl+C to stop the runner"
  log_info ""
  log_info "📋 Workflow: Create PR to main/develop → Actions auto-trigger → Watch in GitHub UI"
  log_info ""

  # Run in foreground (allows Ctrl+C to stop)
  ./run.sh
}

runner_stop() {
  log_info "Stopping runner..."

  if ! pgrep -f "Runner.Listener" > /dev/null; then
    log_warning "Runner not running"
    return 0
  fi

  # Kill the runner process gracefully
  pkill -f "Runner.Listener" || true
  sleep 2

  # Force kill if still running
  pkill -9 -f "Runner.Listener" || true

  log_success "Runner stopped"
}

runner_config() {
  log_info "Configuring runner..."

  if [ ! -d "$RUNNER_DIR" ]; then
    log_error "Runner directory not found: $RUNNER_DIR"
    exit 1
  fi

  cd "$RUNNER_DIR"

  log_info "Running configuration script..."
  ./config.sh --url "$REPO_URL" || true

  log_success "Runner configured"
  log_info "Next: run './scripts/ci/runner.sh start' to launch"
}

show_usage() {
  cat << 'USAGE'
On-Demand Self-Hosted Runner Launcher

USAGE: ./scripts/ci/runner.sh [command]

COMMANDS:
  start    Start runner in foreground (Ctrl+C to stop)
  stop     Stop running runner
  status   Check runner status
  config   Configure runner (interactive)
  help     Show this help message

WORKFLOW:
  1. ./scripts/ci/runner.sh start
  2. Create PR to main or develop branch
  3. GitHub Actions auto-triggers workflows on self-hosted runner
  4. Watch Actions tab in GitHub UI
  5. Ctrl+C to stop runner when done

EXAMPLE:
  Terminal 1:                     Terminal 2:
  $ ./scripts/ci/runner.sh start  $ git checkout -b feature/xyz
                                  $ git add .
                                  $ git commit -m "feat: xyz"
                                  $ git push origin feature/xyz
                                  $ # Create PR on GitHub
                                  $ # Watch workflows run

TROUBLESHOOTING:
  - Check: ./scripts/ci/runner.sh status
  - Logs: tail -f ~/actions-runner/_diag/Worker_*.log
  - Health: ./scripts/ci/runner-health.sh

USAGE
}

# Main
main() {
  local command="${1:-help}"

  case "$command" in
    start)
      runner_start
      ;;
    stop)
      runner_stop
      ;;
    status)
      runner_status
      ;;
    config)
      runner_config
      ;;
    help|--help|-h)
      show_usage
      ;;
    *)
      log_error "Unknown command: $command"
      show_usage
      exit 1
      ;;
  esac
}

main "$@"
