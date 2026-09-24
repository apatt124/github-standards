---
inclusion: always
---

# Documentation Standards

## Documentation Location

**CRITICAL RULE:** All documentation files (`.md` files) MUST be placed in the `docs/` folder, NOT in the root directory.

### Correct Location

✅ Place all documentation under `docs/` in the relevant repo:
- `docs/guides/` — How-to guides and tutorials
- `docs/technical/` — Technical specifications and architecture docs
- `docs/analysis/` — Analysis, audits, and investigation documents
- `docs/implementation-history/` — Implementation summaries and completion notes
- `docs/` — General documentation that doesn't fit a subfolder

❌ **NEVER place documentation here:**
- Repo root (e.g. `SOME_DOC.md` alongside `package.json` or `main.py`)
- Inside source code folders (e.g. `src/SETUP_GUIDE.md`)

### Exceptions

The ONLY markdown files that belong in the root:
- `README.md` — project overview
- `CONTRIBUTING.md` — contribution guidelines
- `CHANGELOG.md` — version history
- `LICENSE.md` — license

### When Creating Documentation

1. **Determine the type:**
   - Guide/Tutorial → `docs/guides/`
   - Technical spec or architecture → `docs/technical/`
   - Analysis/Audit → `docs/analysis/`
   - Implementation notes → `docs/implementation-history/`
   - General → `docs/`

2. **Use descriptive filenames** in UPPERCASE_WITH_UNDERSCORES (e.g. `COGNITO_SETUP.md`, `AWS_PERMISSIONS.md`)

3. **Never create in root:**
   ```
   # WRONG
   COGNITO_SETUP.md

   # RIGHT
   docs/guides/COGNITO_SETUP.md
   ```

### Moving Existing Documentation

If you find documentation in the wrong location:
1. Move it to the appropriate `docs/` subfolder
2. Update any references to the file
3. Commit the move

### Summary

**Simple rule:** If it's a `.md` file and not README/CONTRIBUTING/CHANGELOG/LICENSE, it goes in `docs/`.
