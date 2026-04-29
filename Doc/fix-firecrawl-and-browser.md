# Fixing Firecrawl & Browser on Headless Linux

> **Date:** April 28, 2026  
> **System:** Ubuntu 24.04 LTS (headless VM)  
> **Problem:** Firecrawl and `agent-browser` failed due to missing system libraries and Chrome sandbox restrictions

---

## Table of Contents

- [Firecrawl Fix](#firecrawl-fix)
- [Browser (agent-browser) Fix](#browser-agent-browser-fix)
- [File Structure](#file-structure)
- [Verification](#verification)
- [Quick Copy-Paste Summary](#quick-copy-paste-summary)

---

## Firecrawl Fix

### Symptoms

```
Error: Could not find Chrome (ver. 131.0.6778.204).
```

Firecrawl requires a Chromium runtime plus several system libraries that are absent on minimal Ubuntu server installs.

### Step 1: Install System Dependencies

```bash
sudo apt-get update && sudo apt-get install -y \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libcups2 \
  libxcomposite1 \
  libxss1 \
  libxdamage1 \
  libgbm1 \
  libnss3 \
  fonts-liberation \
  libx11-xcb1 \
  libxkbcommon-x11-0 \
  xdg-utils \
  fonts-noto-color-emoji
```

**What each package does:**

| Package | Purpose |
|---|---|
| `libatk1.0-0`, `libatk-bridge2.0-0` | Accessibility toolkit — required for Chrome UI rendering |
| `libcups2` | CUPS printing library — loaded by Chrome at startup |
| `libxcomposite1` | X11 composite extension for window compositing |
| `libxss1` | X11 Screen Saver extension |
| `libxdamage1` | X11 damage extension for incremental rendering |
| `libgbm1` | Generic Buffer Management — GPU acceleration |
| `libnss3` | Network Security Services — SSL/TLS certificate handling |
| `fonts-liberation` | Liberation fonts — baseline text rendering |
| `libx11-xcb1` | X11 → XCB bridge |
| `libxkbcommon-x11-0` | Keyboard input handling |
| `xdg-utils` | Desktop integration utilities |
| `fonts-noto-color-emoji` | Emoji font support |

### Step 2: Install Firecrawl Browser Dependencies

```bash
npx @firecrawl-ui/firecrawl-js@latest browser-with-system-deps install
```

This installs the Playwright Chromium bundle and all system-level dependencies it requires.

### Step 3: Verify

Firecrawl should now work as the backend for `web_search` and `web_extract` tools in Hermes Agent.

---

## Browser (agent-browser) Fix

### Symptoms

```
[error] [browser] Browser crashed with exit code 1:
[0428/214921.989920:ERROR:zygote_host_impl_linux.cc(97)] No usable sandbox!
```

Chrome/Chromium in headless mode on Linux requires a working sandbox. On systems without nested virtualization (most VPS and cloud servers), the sandbox cannot initialize and Chrome crashes at startup.

### Solution: Disable the Sandbox

#### Method 1: Config File (Recommended ✅)

**File:** `~/.agent-browser/config.json`

```json
{
  "args": "--no-sandbox"
}
```

This config is read on every agent-browser launch and appends `--no-sandbox` to the Chrome command line.

#### Method 2: Environment Variable (Alternative)

**File:** `~/.hermes/.env`

```bash
AGENT_BROWSER_ARGS="--no-sandbox"
```

> **Warning:** After editing `.env`, restart the Hermes gateway so new variables take effect. The config file approach is more reliable.

### What Does `--no-sandbox` Do?

Normally, Chrome runs child processes inside a Linux sandbox (namespace isolation, seccomp-bpf filters). On headless servers and VPS environments:

- Nested namespaces are often disabled by the host
- Seccomp profiles may conflict with containerization layers
- Sandbox fails to initialize → Chrome crashes on launch

The `--no-sandbox` flag disables this protection. **This is safe** in the agent-browser context because:

- The browser runs in an isolated process
- It has no access to the user's filesystem outside the workspace
- Hermes executes it with restricted privileges

---

## File Structure

```
~/.hermes/
├── .env                          # AGENT_BROWSER_ARGS="--no-sandbox"
├── config.yaml                   # Main Hermes Agent configuration
└── ...

~/.agent-browser/
└── config.json                   # { "args": "--no-sandbox" }
```

---

## Verification

### Browser Test

Ask your Hermes agent to run:

```
browser_navigate(url="https://example.com")
```

✅ Should return a page snapshot.

### Firecrawl Test

Ask your Hermes agent to run:

```
web_search(query="test query")
```

✅ Should return search results.

---

## Quick Copy-Paste Summary

```bash
# 1. Install system libraries (for Firecrawl)
sudo apt-get update && sudo apt-get install -y \
  libatk1.0-0 libatk-bridge2.0-0 libcups2 libxcomposite1 \
  libxss1 libxdamage1 libgbm1 libnss3 fonts-liberation \
  libx11-xcb1 libxkbcommon-x11-0 xdg-utils fonts-noto-color-emoji

# 2. Install Firecrawl browser dependencies
npx @firecrawl-ui/firecrawl-js@latest browser-with-system-deps install

# 3. Disable sandbox (for agent-browser)
mkdir -p ~/.agent-browser
echo '{"args": "--no-sandbox"}' > ~/.agent-browser/config.json

# 4. (Optional) Add to .env as well
echo 'AGENT_BROWSER_ARGS="--no-sandbox"' >> ~/.hermes/.env
```

---

## Notes

- **Firecrawl** is used internally as the backend for `web_search` and `web_extract` — it powers web search and content extraction from URLs.
- **Browser** (`agent-browser`) handles interactive operations: `browser_navigate`, `browser_click`, `browser_type`, `browser_snapshot`.
- On a desktop system with a proper display server, `--no-sandbox` is unnecessary — the sandbox works normally.
- After Hermes Agent updates, verify that `~/.agent-browser/config.json` still exists.
