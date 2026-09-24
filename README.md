# GitHub Standards

This repository is the **source of truth** for all shared Kiro steering docs and GitHub standards across BridgeFirst repos.

## Contents

### Kiro Steering Docs (`.kiro/steering/`)

These are synced to every BridgeFirst repo via `sync-steering.sh`. Edit here, then run the sync — never edit the copies in individual repos directly.

| File | Purpose | Inclusion |
|---|---|---|
| `browser-devtools.md` | Chrome DevTools vs Playwright MCP — which to use when | always |
| `cli-tools-inventory.md` | Available CLI tools, versions, paths, and usage patterns | always |
| `documentation.md` | Where to put docs (`docs/` folder structure) | always |
| `pr-review.md` | PR review workflow and comment structure | manual |

### GitHub Copilot Standards (`.github/`)

| File | Purpose |
|---|---|
| `copilot-instructions.md` | GitHub Copilot behavior guidelines |
| `kiro-documentation-standards.md` | Documentation formatting standards |

---

## Syncing Steering Docs

Run this whenever you update a shared steering doc:

```bash
cd github-standards
./sync-steering.sh          # sync all repos + ~/.kiro/steering
./sync-steering.sh --dry-run  # preview what would change
./sync-steering.sh --commit   # sync + auto-commit in each repo
```

The script syncs the 4 shared files to:
- `bridgefirst-forecasting-api-v2`
- `bridgefirst-aws-monitoring-dashboard`
- `bridgefirst-forecasting-terraform`
- `bridgefirst-forecasting`
- `bridgefirst-forecasting/bridgefirst-forecasting`
- `~/.kiro/steering` (local sessions)

> **Note:** Some repos have `.kiro/` in their `.gitignore` (currently `bridgefirst-forecasting-api-v2` and `bridgefirst-forecasting-terraform`). Steering files still work locally in those repos but won't be committed to GitHub — Kiro web won't pick them up there. If you need Kiro web support in those repos, remove `.kiro/` from their `.gitignore`.

---

## What Stays Repo-Specific

These steering docs are owned by each individual repo and are **never overwritten by the sync**:

- `git.md` — push/merge policy + repo-specific destructive change flags
- `tech.md` — tech stack details
- `structure.md` — project structure
- `product.md` — product overview
- `terraform.md` — Terraform-specific rules (terraform repo only)
- `ux-patterns.md`, `debug-tools.md`, `backlog.md`, `deployment-infrastructure.md` (frontend repo)

---

## Adding a New Shared Steering Doc

1. Create the file in `.kiro/steering/` here
2. Add it to the `SHARED_FILES` array in `sync-steering.sh`
3. Run `./sync-steering.sh`
4. Commit and push here, then commit in each repo that tracks `.kiro/`

## Adding a New Repo to the Sync

Add the repo path (relative to `~/Documents/alex/bridgeFirst/`) to the `REPOS` array in `sync-steering.sh`.
