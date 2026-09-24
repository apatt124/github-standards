#!/bin/bash

# sync-steering.sh
# Copies shared Kiro steering docs from github-standards into each BridgeFirst repo.
#
# SHARED docs (managed here, synced outward — do not edit in individual repos):
#   browser-devtools.md, cli-tools-inventory.md, documentation.md, pr-review.md
#
# REPO-SPECIFIC docs (owned by each repo — never touched by this script):
#   git.md, tech.md, structure.md, product.md, terraform.md,
#   ux-patterns.md, debug-tools.md, backlog.md, deployment-infrastructure.md
#
# Usage:
#   ./sync-steering.sh            # sync all repos
#   ./sync-steering.sh --dry-run  # preview what would be copied, no changes

set -e

# ── Config ────────────────────────────────────────────────────────────────────

STANDARDS_DIR="$(cd "$(dirname "$0")" && pwd)/.kiro/steering"
BRIDGEFIRST="$HOME/Documents/alex/bridgeFirst"

# Repos to sync into (relative to $BRIDGEFIRST)
REPOS=(
  "bridgefirst-forecasting-api-v2"
  "bridgefirst-aws-monitoring-dashboard"
  "bridgefirst-forecasting-terraform"
  "bridgefirst-forecasting"
  "bridgefirst-forecasting/bridgefirst-forecasting"
)

# Files to sync (must exist in $STANDARDS_DIR)
SHARED_FILES=(
  "browser-devtools.md"
  "cli-tools-inventory.md"
  "documentation.md"
  "pr-review.md"
)

# ── Helpers ───────────────────────────────────────────────────────────────────

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

log_info()    { echo -e "${BLUE}$1${NC}"; }
log_ok()      { echo -e "${GREEN}  ✓ $1${NC}"; }
log_skip()    { echo -e "${YELLOW}  ⊙ $1${NC}"; }
log_error()   { echo -e "${RED}  ✗ $1${NC}"; }
log_dryrun()  { echo -e "${YELLOW}  [dry-run] would copy: $1${NC}"; }

# ── Preflight ─────────────────────────────────────────────────────────────────

log_info "========================================"
log_info "Kiro Steering Sync"
$DRY_RUN && log_info "(dry-run mode — no files will be written)"
log_info "========================================"
echo ""

for f in "${SHARED_FILES[@]}"; do
  if [[ ! -f "$STANDARDS_DIR/$f" ]]; then
    log_error "Source file missing: $STANDARDS_DIR/$f"
    exit 1
  fi
done

log_ok "All source files present in $STANDARDS_DIR"
echo ""

# ── Sync ──────────────────────────────────────────────────────────────────────

TOTAL_COPIED=0
TOTAL_SKIPPED=0

for REPO in "${REPOS[@]}"; do
  REPO_PATH="$BRIDGEFIRST/$REPO"
  STEERING_DIR="$REPO_PATH/.kiro/steering"

  log_info "Repo: $REPO"

  if [[ ! -d "$REPO_PATH" ]]; then
    log_error "Repo path not found: $REPO_PATH"
    echo ""
    continue
  fi

  if ! $DRY_RUN; then
    mkdir -p "$STEERING_DIR"
  fi

  for f in "${SHARED_FILES[@]}"; do
    SRC="$STANDARDS_DIR/$f"
    DST="$STEERING_DIR/$f"

    if $DRY_RUN; then
      log_dryrun "$SRC → $DST"
      ((TOTAL_COPIED++))
    else
      cp "$SRC" "$DST"
      log_ok "Synced $f"
      ((TOTAL_COPIED++))
    fi
  done

  echo ""
done

# ── Also sync to ~/.kiro/steering for local sessions ─────────────────────────

LOCAL_STEERING="$HOME/.kiro/steering"
log_info "Local steering (~/.kiro/steering)"

if [[ ! -d "$LOCAL_STEERING" ]]; then
  log_skip "~/.kiro/steering not found, skipping"
else
  for f in "${SHARED_FILES[@]}"; do
    SRC="$STANDARDS_DIR/$f"
    DST="$LOCAL_STEERING/$f"

    if $DRY_RUN; then
      log_dryrun "$SRC → $DST"
    else
      cp "$SRC" "$DST"
      log_ok "Synced $f to ~/.kiro/steering"
    fi
  done
fi

echo ""

# ── Summary ───────────────────────────────────────────────────────────────────

log_info "========================================"
log_info "Done"
log_info "========================================"
if $DRY_RUN; then
  echo -e "${YELLOW}Dry run complete — no files were written.${NC}"
  echo "Run without --dry-run to apply."
else
  echo -e "${GREEN}Synced ${TOTAL_COPIED} file(s) across ${#REPOS[@]} repos + ~/.kiro/steering.${NC}"
  echo ""
  echo "Next steps:"
  echo "  1. Review changes:  git diff in each repo"
  echo "  2. Commit and push: cd into each repo, commit .kiro/steering/ changes"
  echo "  Or run the commit helper below to do it all at once:"
  echo "     ./sync-steering.sh --commit"
fi
echo ""

# ── Optional auto-commit ──────────────────────────────────────────────────────

if [[ "${1:-}" == "--commit" ]]; then
  echo ""
  log_info "Committing steering sync in each repo..."
  echo ""

  for REPO in "${REPOS[@]}"; do
    REPO_PATH="$BRIDGEFIRST/$REPO"
    [[ ! -d "$REPO_PATH" ]] && continue

    cd "$REPO_PATH"

    CHANGED=$(git diff --name-only .kiro/steering/ 2>/dev/null || true)
    UNTRACKED=$(git ls-files --others --exclude-standard .kiro/steering/ 2>/dev/null || true)

    if [[ -z "$CHANGED" && -z "$UNTRACKED" ]]; then
      log_skip "$REPO — no changes"
      continue
    fi

    git add .kiro/steering/
    git commit -m "chore: sync shared Kiro steering docs from github-standards"
    log_ok "$REPO — committed"
  done

  echo ""
  log_info "All repos committed. Push each when ready (following your push policy)."
fi
