---
inclusion: manual
---

# PR Review Standards

When asked to review a pull request, always:

1. **Fetch the full diff** using `gh pr diff <number> --repo <owner>/<repo>` before forming any opinion. Do not review from memory or partial context.

2. **Post the review as a GitHub comment** using `gh pr comment <number> --repo <owner>/<repo> --body-file <file>` so it is visible on the PR for the team to read. Do not just summarize in chat.
   - Write the comment body to a temp file first (e.g. `/tmp/pr-review.md`) to avoid shell escaping issues with backticks and special characters
   - **Delete the temp file after posting** — `rm /tmp/pr-review.md`

3. **Structure the review comment** with these sections:
   - **Summary** — one paragraph on what the PR does and overall assessment
   - **Issues** — numbered list of bugs, correctness problems, or security concerns. Mark each as `[blocking]` or `[non-blocking]`
   - **Observations** — things worth noting that aren't bugs (dead code, inconsistencies, style drift, missing tests)
   - **Verdict** — one of: `✅ Approve`, `⚠️ Approve with notes`, or `🚫 Request changes`

4. **Be specific** — reference file names and line context, not vague descriptions.

5. **Be honest** — if you wrote the code being reviewed, say so and flag anything you're uncertain about. Self-review is lower confidence than independent review.

6. **Check for**:
   - Env vars or secrets accidentally committed
   - Dead imports or unused variables introduced
   - Inconsistencies between related files (e.g. two versions of the same file both modified)
   - Build/pipeline impact (new build steps, new dependencies, CI changes)
   - Security implications (CORS, CSP, auth, data exposure)
   - Whether the PR description matches what the diff actually does

7. If the `semantic_reviewer` sub-agent wrote a review file into the repo (e.g. `semantic-review/*.md`), **delete it** — these are transient artifacts, not committed docs. The PR comment is the permanent tracking record.
