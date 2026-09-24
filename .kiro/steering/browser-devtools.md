---
inclusion: always
---

# Browser Tools Usage

Two browser MCP servers are available. Use the right one for the job.

---

## Which Tool to Use

### Chrome DevTools MCP (`mcp_chrome_devtools_*`)
**Use for debugging and inspection:**
- Network request/response inspection (`list_network_requests`, `get_network_request`)
- Console error checking (`list_console_messages`)
- Performance auditing (`lighthouse_audit`, `performance_start_trace`)
- Heap snapshots and memory analysis
- JavaScript evaluation against a live page (`evaluate_script`)
- Any task that requires DevTools-level visibility into what the browser is doing

### Playwright MCP (`browser_*`)
**Use for UI automation and visual verification:**
- Navigating to pages and clicking elements
- Filling forms
- Taking screenshots to verify visual state
- Waiting for elements or text to appear
- Any multi-step UI workflow where speed matters

**Why Playwright is faster for UI tasks:** It returns minimal confirmations on actions (not full page snapshots), so each round-trip is significantly smaller. On complex pages, Chrome DevTools snapshots can be 100x+ larger per action.

---

## Decision Rule

- Need to **see what's happening** (errors, network, performance)? → Chrome DevTools MCP
- Need to **do something** in the UI (click, fill, navigate, verify visually)? → Playwright MCP
- Need both? Open a Chrome DevTools tab for inspection and use Playwright for interactions.

---

## Tab Management

**Always close browser tabs/pages you open when you are done with them.**

- Chrome DevTools: use `mcp_chrome_devtools_close_page`
- Playwright: use `browser_close`
- Never leave tabs open at the end of a session or task
- If multiple tabs were opened, close all of them before finishing

---

## Efficient Usage Patterns

### Chrome DevTools — avoid redundant snapshots
- Only call `take_snapshot` when you need to identify a specific element's UID
- For reading data from a page, prefer `evaluate_script` — one call can collect everything
- Set `waitForStableDom: false` when only reading, not triggering DOM changes
- Use `fill_form` over multiple individual `fill` calls

### Playwright — batch reads
- Use `browser_snapshot` once to understand structure, then act — don't snapshot before every action
- Chain navigate → interact → verify without intermediate snapshot calls when page structure is predictable

---

## Common Workflows

### Checking an API response in the browser
1. `mcp_chrome_devtools_navigate_page` to the relevant URL
2. `mcp_chrome_devtools_list_network_requests` to find the request
3. `mcp_chrome_devtools_get_network_request` to inspect headers and body
4. Close the tab

### Verifying UI after a code change
1. `browser_navigate` to the page
2. `browser_screenshot` or `browser_snapshot` to verify state
3. `browser_close`

### Debugging a console error
1. `mcp_chrome_devtools_navigate_page` to reproduce the error
2. `mcp_chrome_devtools_list_console_messages` filtered to `error`/`warn`
3. Optionally `mcp_chrome_devtools_get_console_message` for stack traces
4. Close the tab
