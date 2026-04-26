#!/usr/bin/env bash
# One-shot bootstrap for the Apollo-like agent system.
# Run this once on a fresh machine. Safe to re-run (idempotent).
#
# It will:
#   1. Verify Node >= 22 and pnpm
#   2. Install gh CLI if missing (uses sudo for apt)
#   3. Authenticate gh if not already (interactive — opens browser)
#   4. Refresh gh scopes (project, read:project, repo)
#   5. Run scripts/sync-tasks-to-github.sh to mirror tasks → Issues + Project
#   6. Run scripts/update-status.sh to refresh STATUS.md
#
# After this completes you can drive the team from Claude Code with:
#   /phase, /next-task, /assign <agent>, /review, /standup, /demo <N>

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# ---------- terminal helpers ----------
if [[ -t 1 ]]; then
  GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'; RED=$'\033[0;31m'; BLUE=$'\033[0;34m'; BOLD=$'\033[1m'; RESET=$'\033[0m'
else
  GREEN=""; YELLOW=""; RED=""; BLUE=""; BOLD=""; RESET=""
fi

step()  { printf "\n${BLUE}${BOLD}==>${RESET} ${BOLD}%s${RESET}\n" "$1"; }
ok()    { printf "${GREEN}✓${RESET} %s\n" "$1"; }
warn()  { printf "${YELLOW}!${RESET} %s\n" "$1"; }
fail()  { printf "${RED}✗${RESET} %s\n" "$1" >&2; }
info()  { printf "  %s\n" "$1"; }

ask_yes_no() {
  local prompt="$1" default="${2:-n}"
  local hint="[y/N]"; [[ "$default" == "y" ]] && hint="[Y/n]"
  local ans
  read -r -p "$prompt $hint " ans
  ans="${ans:-$default}"
  [[ "$ans" =~ ^[Yy]$ ]]
}

# ---------- 1. Node + pnpm ----------
step "1/6  Checking Node.js >= 22"
if ! command -v node >/dev/null 2>&1; then
  fail "node not found. Install Node 22+ first (try: nvm install 22)"
  exit 1
fi
node_major="$(node -p 'process.versions.node.split(".")[0]')"
if [[ "$node_major" -lt 22 ]]; then
  fail "node $($node --version) detected; need >= 22"
  exit 1
fi
ok "node $(node --version)"

step "2/6  Checking pnpm"
if ! command -v pnpm >/dev/null 2>&1; then
  warn "pnpm not found"
  if ask_yes_no "Install pnpm globally with corepack?" "y"; then
    if command -v corepack >/dev/null 2>&1; then
      corepack enable >/dev/null 2>&1 || true
      corepack prepare pnpm@latest --activate
    else
      npm install -g pnpm@latest
    fi
  else
    fail "pnpm is required. Aborting."
    exit 1
  fi
fi
ok "pnpm $(pnpm --version)"

# ---------- 3. gh CLI ----------
step "3/6  Checking GitHub CLI (gh)"
if ! command -v gh >/dev/null 2>&1; then
  warn "gh not found"
  if ! ask_yes_no "Install gh now? (uses sudo apt)" "y"; then
    fail "gh is required for GitHub board sync. Aborting."
    exit 1
  fi
  if ! command -v sudo >/dev/null 2>&1; then
    fail "sudo not available. Install gh manually: https://cli.github.com"
    exit 1
  fi
  info "installing gh via apt..."
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  arch="$(dpkg --print-architecture)"
  echo "deb [arch=${arch} signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt update -qq
  sudo apt install -y gh
fi
ok "gh $(gh --version | head -1)"

# ---------- 4. gh auth ----------
step "4/6  GitHub authentication"
if gh auth status >/dev/null 2>&1; then
  ok "gh already authenticated"
else
  warn "gh not authenticated"
  info "A browser window will open. Choose: GitHub.com → SSH (since you already have SSH set up) → Login with web browser"
  gh auth login
fi

# Make sure project scope is granted
if ! gh auth status 2>&1 | grep -qE "project|read:project"; then
  warn "project scope missing — refreshing"
  gh auth refresh -s project,read:project,repo
else
  ok "scopes OK (includes project)"
fi

# ---------- 5. tasks → Issues + Project ----------
step "5/6  Mirroring tasks.md → GitHub Issues + Project"
if [[ ! -x scripts/sync-tasks-to-github.sh ]]; then
  fail "scripts/sync-tasks-to-github.sh not found or not executable"
  exit 1
fi
bash scripts/sync-tasks-to-github.sh

# ---------- 6. STATUS.md refresh ----------
step "6/6  Refreshing STATUS.md"
bash scripts/update-status.sh

# ---------- summary ----------
repo_nwo="$(gh repo view --json nameWithOwner --jq .nameWithOwner)"
owner="${repo_nwo%/*}"
proj_num="$(gh project list --owner "$owner" --format json 2>/dev/null \
  | jq -r '.projects[]? | select(.title=="Apollo-like") | .number' | head -1 || true)"

cat <<EOF

${GREEN}${BOLD}Bootstrap complete.${RESET}

Repo:    https://github.com/${repo_nwo}
Issues:  https://github.com/${repo_nwo}/issues
Project: https://github.com/users/${owner}/projects/${proj_num:-?}
Status:  $(awk -F'/' '/Overall:/{print; exit}' docs/STATUS.md 2>/dev/null || echo "see docs/STATUS.md")

${BOLD}Next${RESET} — open Claude Code in this directory and run:

  /phase         # see where the project stands
  /assign po     # let the Product Owner pick up TASK-001
  /next-task     # or let PM dispatch 1-3 tasks in parallel

Re-run this script anytime to re-sync the GitHub board.
EOF
