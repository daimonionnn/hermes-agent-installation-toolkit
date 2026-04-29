# Installing Chrome DevTools MCP Server on Hermes Agent

This guide documents how to set up the [Chrome DevTools MCP](https://github.com/ChromeDevTools/chrome-devtools-mcp) server with Hermes Agent for browser automation, web scraping, authenticated sessions, and DOM inspection.

---

## Table of Contents

- [What Is Chrome DevTools MCP?](#what-is-chrome-devtools-mcp)
- [Prerequisites](#prerequisites)
- [Step 1: Install Google Chrome (Non-Sandboxed)](#step-1-install-google-chrome-non-sandboxed)
- [Step 2: Configure Hermes Agent](#step-2-configure-hermes-agent)
- [Step 3: Verify the Setup](#step-3-verify-the-setup)
- [Available Tools](#available-tools)
- [Authentication Workflows](#authentication-workflows)
- [Known Issues & Troubleshooting](#known-issues--troubleshooting)
- [Important Notes](#important-notes)

---

## What Is Chrome DevTools MCP?

Chrome DevTools MCP is a **Model Context Protocol (MCP)** server that exposes browser capabilities through the [Chrome DevTools Protocol (CDP)](https://chromedevtools.github.io/devtools-protocol/). It enables:

- **Browser automation** — navigate pages, click elements, fill forms
- **DOM inspection** — accessibility tree snapshots with element UIDs
- **Screenshots** — visual capture of full pages and individual elements
- **Network monitoring** — inspect HTTP requests and responses in real time
- **JavaScript execution** — evaluate arbitrary scripts in the page context
- **Persistent sessions** — authentication state survives across tool calls

This is especially useful for web scraping behind paywalls, logging into websites programmatically, and automating browser workflows without headless Selenium/Puppeteer overhead.

---

## Prerequisites

- **Node.js & npm** installed (for `npx`)
- **Hermes Agent** configured and running
- **Google Chrome or Chromium** (non-snap) installed on the system

---

## Step 1: Install Google Chrome (Non-Sandboxed)

### ⚠️ Critical: Do NOT Use Snap Chromium

Snap-installed Chromium runs in a sandbox that blocks Chrome DevTools Protocol (CDP) connections. This is a hard constraint — CDP simply won't work with Snap packages.

```bash
# ❌ DO NOT USE — Snap packages will fail
which chromium  # if this resolves to /usr/bin/snap, it's sandboxed

# ✅ Check for non-sandboxed browser
which google-chrome-stable
# → /usr/bin/google-chrome-stable
```

### Installing Google Chrome on Ubuntu / Debian

```bash
wget -q -O /tmp/google-chrome.deb \
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i /tmp/google-chrome.deb
sudo apt-get install -f -y   # Fix missing dependencies if needed
rm /tmp/google-chrome.deb
```

### Verifying the Installation

```bash
google-chrome-stable --version
# → e.g., "Google Chrome 125.0.xxxx.xx"
```

---

## Step 2: Configure Hermes Agent

Add the MCP server entry to your `~/.hermes/config.yaml`:

```yaml
mcp_servers:
  chrome-devtools:
    command: "npx"
    args: ["-y", "chrome-devtools-mcp@latest", "--browser-path=/usr/bin/google-chrome-stable"]
    timeout: 60
    connect_timeout: 30
```

### Configuration Explained

| Parameter | Value | Description |
|---|---|---|
| `command` | `npx` | Runs the MCP server via npx (auto-installs on first run) |
| `args` | `-y chrome-devtools-mcp@latest` | Pulls latest version without prompts |
| `--browser-path` | `/usr/bin/google-chrome-stable` | **Required** — path to non-sandboxed Chrome binary |
| `timeout` | `60` | Request timeout in seconds (increase for slow pages) |
| `connect_timeout` | `30` | Connection timeout for CDP handshake |

### Alternative: Connecting to an Existing Chrome Instance

If you already have Chrome running with remote debugging enabled, point MCP at it:

```yaml
mcp_servers:
  chrome-devtools:
    command: "npx"
    args: ["-y", "chrome-devtools-mcp@latest", "--cdp-endpoint=http://127.0.0.1:9222"]
    timeout: 60
    connect_timeout: 30
```

> **Note:** With `--cdp-endpoint`, MCP does **not** manage the browser lifecycle — you are responsible for starting Chrome with `--remote-debugging-port=9222`.

---

## Step 3: Verify the Setup

After saving `config.yaml`, restart Hermes Agent. The MCP server auto-starts on next invocation.

### Test Navigation

```
mcp_chrome_devtools_navigate_page(url="https://example.com", type="url")
```

### Take a Snapshot

```
mcp_chrome_devtools_take_snapshot(verbose=false)
```

### Expected Output

A text-based accessibility tree with element UIDs:

```
- generic
  - banner
    - heading "Example Domain" [level=1]
    - paragraph
      - StaticText "This domain is for use in illustrative examples..."
      - link "More information..." [uid="e5"]
```

---

## Available Tools

All tools are prefixed with `mcp_chrome_devtools_`:

| Tool | Description |
|---|---|
| `navigate_page` | Navigate to URLs, go back/forward, reload |
| `take_snapshot` | Get text-based DOM snapshot with element UIDs |
| `click` | Click elements by UID (single or double click) |
| `fill` | Type text into input fields |
| `fill_form` | Fill multiple form elements at once |
| `take_screenshot` | Capture visual screenshots (PNG / JPEG / WebP) |
| `list_pages` | List all open tabs and pages |
| `evaluate_script` | Run JavaScript in the page context |
| `hover` | Hover over elements |
| `drag` | Drag-and-drop between elements |
| `upload_file` | Upload files through file inputs |
| `press_key` | Press keyboard keys and shortcuts |
| `list_network_requests` | Inspect HTTP requests and responses |
| `get_network_request` | Get details of a specific network request |
| `list_console_messages` | Read browser console output (logs, errors, warnings) |
| `emulate` | Emulate devices, network throttling, geolocation |
| `lighthouse_audit` | Run Lighthouse accessibility / SEO audits |
| `performance_start_trace` | Start performance profiling traces |

> **Naming convention:** `mcp_{server}_{tool}` with hyphens converted to underscores. Server name `chrome-devtools` becomes `mcp_chrome_devtools_*`.

---

## Authentication Workflows

Chrome DevTools MCP maintains full browser session state across all tool calls. Once you log in, authentication persists for the lifetime of the browser process.

### Example: Logging into Substack

```
# Step 1: Navigate to login page
mcp_chrome_devtools_navigate_page(url="https://substack.com/sign_in", type="url")

# Step 2: Take snapshot to find element UIDs
mcp_chrome_devtools_take_snapshot(verbose=false)

# Step 3: Fill email field (use UID from snapshot)
mcp_chrome_devtools_fill(uid="e123", value="user@email.com")

# Step 4: Click continue button
mcp_chrome_devtools_click(uid="e124")

# Step 5: Enter verification code when prompted
mcp_chrome_devtools_fill(uid="e125", value="123456")

# ✅ Session is now authenticated — all subsequent navigations stay logged in
```

### Persistence Guarantees

- Authentication state survives across page navigations within the same session
- Cookies and `localStorage` are preserved while the browser process is alive
- The browser process stays running as long as Hermes Agent is active

---

## Known Issues & Troubleshooting

### ❌ "Protocol error (Target.setDiscoverTargets): Target closed"

**Root cause:** Snap Chromium sandbox blocks CDP connections.  
**Fix:** Install Google Chrome via `.deb` package — see [Step 1](#step-1-install-google-chrome-non-sandboxed).

### ❌ MCP Server Fails to Start

Check the logs:

```bash
cat ~/.hermes/logs/mcp-stderr.log | grep chrome-devtools
```

Common fixes:
- Verify `--browser-path` points to an existing binary
- Ensure Node.js is installed and `npx` works from your shell
- Increase `timeout` if Chrome takes a long time to start on slow hardware

### ❌ Tools Return "Server Not Available"

The MCP server process may have crashed. Restart Hermes Agent or check whether the Chrome process is still running:

```bash
ps aux | grep chrome-devtools-mcp
```

---

## Important Notes

1. **MCP manages browser lifecycle** — Don't manually start headless Chrome unless using `--cdp-endpoint` mode. The MCP server handles launching and shutting down the browser automatically.

2. **Session isolation** — Each Hermes Agent session gets its own browser instance. Cron jobs run in isolated sessions and do **not** share cookies with interactive terminal sessions.

3. **Snap = No CDP** — This is a hard constraint. If Ubuntu auto-installed Chromium via snap, switch to Google Chrome or install from the official PPA.

4. **Timeout tuning** — For pages with heavy JavaScript (SPAs, paywalled content), increase `timeout: 60` to `120` or higher.

5. **Element UIDs are dynamic** — The `uid` values in snapshots change between page loads. Always take a fresh snapshot before clicking or filling elements.

---

## References

- [Chrome DevTools MCP on GitHub](https://github.com/ChromeDevTools/chrome-devtools-mcp)
- [Hermes Agent Documentation](https://hermes-agent.nousresearch.com/docs)
- [Chrome DevTools Protocol (CDP)](https://chromedevtools.github.io/devtools-protocol/)
