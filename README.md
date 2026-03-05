# GitHub Standards

This repository contains centralized GitHub Copilot instructions and documentation standards that are automatically synced to all my repositories.

## Files

- `copilot-instructions.md` - GitHub Copilot behavior guidelines
- `kiro-documentation-standards.md` - Documentation formatting standards

## How It Works

When these files are updated and pushed to `main`, a GitHub Action automatically:
1. Detects the changes
2. Creates PRs in all my repositories
3. Updates the `.github/` directory in each repo

## Updating Standards

1. Edit the files in this repository
2. Commit and push to `main`
3. GitHub Actions will sync to all repos automatically

## Manual Sync

To manually trigger a sync:

```bash
gh workflow run sync-standards.yml
```

## Adding New Repositories

New repositories automatically receive these standards when the sync workflow runs.

## Source of Truth

This repository is the source of truth for all my GitHub repositories.

## Local Copy

These files are also maintained in `~/.kiro/` for Kiro AI assistant to use globally.

## Test Update

Testing auto-sync functionality - this line will trigger the workflow.
