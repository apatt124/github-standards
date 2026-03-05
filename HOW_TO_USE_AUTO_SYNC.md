# How to Use the Auto-Sync Workflow

The `github-standards` repository automatically syncs GitHub Copilot instructions and Kiro documentation standards to all your repositories.

## How It Works

When you update either of these files in the `github-standards` repository:
- `copilot-instructions.md`
- `kiro-documentation-standards.md`

The workflow automatically:
1. Detects the change
2. Clones all your non-archived, non-fork repositories
3. Creates a new branch in each repo
4. Copies the updated files to `.github/` directory
5. Creates a pull request with the changes

## Automatic Triggers

The workflow runs automatically when you:
- Push changes to `main` branch that modify either standard file
- The commit includes `[skip ci]` to prevent triggering CI/CD builds in target repos

## Manual Trigger

You can also manually trigger the sync workflow:

### Via GitHub Web Interface

1. Go to https://github.com/apatt124/github-standards/actions
2. Click on "Sync Standards to All Repos" workflow
3. Click the "Run workflow" button (top right)
4. Select the `main` branch
5. Click "Run workflow"

### Via GitHub CLI

```bash
gh workflow run sync-standards.yml --repo apatt124/github-standards
```

## Updating Standards

To update standards across all repositories:

1. Edit `copilot-instructions.md` or `kiro-documentation-standards.md` in this repo
2. Commit and push to `main` branch
3. The workflow runs automatically
4. Review and merge the PRs created in each repository

## Example Workflow

```bash
# Clone the standards repo
cd ~/Documents/alex/bridgeFirst/github-standards

# Edit the standards
vim copilot-instructions.md

# Commit and push
git add copilot-instructions.md
git commit -m "docs: update coding standards"
git push origin main

# Workflow runs automatically and creates PRs in all repos
```

## Checking Sync Status

View recent workflow runs:
```bash
gh run list --repo apatt124/github-standards --limit 5
```

View PRs created in a specific repo:
```bash
gh pr list --repo apatt124/your-repo-name
```

## Configuration

The workflow is configured in `.github/workflows/sync-standards.yml` and uses:
- `STANDARDS_SYNC_TOKEN` secret for authentication
- Targets all non-archived, non-fork repositories under your account
- Creates PRs against the default branch (usually `main` or `develop`)

## Notes

- PRs include `[skip ci]` to prevent triggering builds in target repos
- The workflow skips the `github-standards` repo itself
- Each sync creates a unique branch name with timestamp
- If no changes are detected in a repo, no PR is created
