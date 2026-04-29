# Migrating from OpenClaw to Hermes Agent

This guide walks you through archiving your OpenClaw workspace and cleanly switching to Hermes Agent without losing your data.

---

## Table of Contents

- [Step 1: Stop OpenClaw Services](#step-1-stop-openclaw-services)
- [Step 2: Archive the OpenClaw Workspace](#step-2-archive-the-openclaw-workspace)
- [Step 3: Disable OpenClaw Systemd Service](#step-3-disable-openclaw-systemd-service)
- [Step 4: Import Data into Hermes (Optional)](#step-4-import-data-into-hermes-optional)
- [What Gets Migrated & What Doesn't](#what-gets-migrated--what-doesnt)

---

## Step 1: Stop OpenClaw Services

Before doing anything, stop the running OpenClaw gateway to prevent file conflicts:

```bash
systemctl --user stop openclaw-gateway.service
```

---

## Step 2: Archive the OpenClaw Workspace

Run the built-in cleanup command. This renames `~/.openclaw` to `~/.openclaw.pre-migration`:

```bash
hermes claw cleanup
```

**Expected output:**

```
✓ Archived: /home/user/.openclaw → /home/user/.openclaw.pre-migration
```

Your data is preserved — Hermes just moves it out of the way so both agents don't read conflicting configs.

---

## Step 3: Disable OpenClaw Systemd Service

Prevent OpenClaw from restarting and recreating its workspace structure:

```bash
systemctl --user disable openclaw-gateway.service
```

Verify it's disabled:

```bash
systemctl --user list-unit-files | grep openclaw
# Should show: openclaw-gateway.service → disabled
```

---

## Step 4: Import Data into Hermes (Optional)

After launching Hermes for the first time, you can ask the agent to read and import selected files from your archived workspace:

> "Read my archived OpenClaw files at `~/.openclaw.pre-migration/` and import my stored articles, notes, and knowledge base entries."

### What to Import

| Content | Recommended? | Notes |
|---|---|---|
| ✅ Stored `.md` articles / notes | **Yes** | Hermes can ingest these into its knowledge system |
| ✅ Links and bookmarks | **Yes** | Useful reference material |
| ❌ API keys & credentials | **No** — configure fresh in `~/.hermes/.env` |
| ❌ Tool configurations | **No** — many OpenClaw tools don't have Hermes equivalents |
| ❌ `sould.md` / persona files | **No** — Hermes has its own personality system |

> **Tip:** Don't try to migrate settings wholesale. Many OpenClaw configs are not compatible with Hermes. It's cleaner to re-configure from scratch and only import content data.

---

## What Gets Migrated & What Doesn't

### ✅ Safe to Import

- Articles and research notes (`.md` files)
- Link collections and bookmarks
- Custom scripts or utilities you wrote
- Knowledge base entries

### ⛔ Do NOT Migrate

- API keys — set them up fresh via `hermes setup` or by editing `~/.hermes/.env`
- Tool provider configs — Hermes uses a different config schema
- Personality / soul files — Hermes has its own persona system loaded from the config directory
- Memory / session state — these are agent-specific and not cross-compatible

---

## Troubleshooting

### Hermes Still Reads OpenClaw Configs

If you notice the agent getting confused after migration:

```bash
# Double-check the archive exists
ls -la ~/.openclaw.pre-migration/

# Make sure no symlinks or leftover dirs point to it
find ~ -name ".openclaw" -not -path "*/.openclaw.pre-migration/*" 2>/dev/null
```

### Re-Run Cleanup Anytime

The cleanup command is idempotent — you can run it again if needed:

```bash
hermes claw cleanup
```
