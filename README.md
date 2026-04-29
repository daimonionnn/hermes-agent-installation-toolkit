# 🐉 Hermes Agent Installation Toolkit

A practical guide and set of scripts for installing **Hermes Agent** — a fully self-hosted, offline-capable AI agent — on Linux systems. Includes setup for local LLM inference, browser automation, web search backends, Chrome DevTools MCP integration, and migration from OpenClaw.

[![Hermes Agent](https://img.shields.io/badge/Hermes-v0.11.0-blue)](https://hermes-agent.nousresearch.com/) [![Platform](https://img.shields.io/badge/Platform-Linux-green)](https://ubuntu.com/) [![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

> **Official docs:** <https://hermes-agent.nousresearch.com/docs>

---

## 📋 Tested Environment

| Component | Spec |
|---|---|
| OS | Ubuntu 24.04 / 25.04 LTS |
| CPU | AMD Ryzen 7 5700G (or similar) |
| RAM | 64 GB |
| GPU | NVIDIA GeForce RTX 5090 32 GB VRAM |
| LLM | Qwen 3.6 27B Q4\_M via LM Studio (local, OpenAI-compatible API) |

---

## 🚀 Quick Start

```bash
# 1. Install Hermes Agent
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# 2. Run the setup wizard
hermes setup

# 3. Start chatting or launch the gateway
hermes
hermes gateway start
```

> **Video walkthrough:** [YouTube — Hermes AI Agent Setup](https://www.youtube.com/watch?v=THA8Fov44QY)

---

## 📂 Documentation

| Guide | Description |
|---|---|
| [Fix Firecrawl & Browser on Headless Linux](Doc/fix-firecrawl-and-browser.md) | Resolving missing system libraries, sandbox issues, and `--no-sandbox` configuration |
| [Install Chrome DevTools MCP Server](Doc/install-mcp-chrome-dev-tools.md) | Setting up browser automation with persistent sessions via CDP |
| [Migrate from OpenClaw](Doc/openclaw_migration.md) | Archiving your OpenClaw workspace and importing data into Hermes |

---

## 🛠️ What's Included

```
Hermes-Agent-Installation-Toolkit/
├── README.md                          # You are here
├── Doc/
│   ├── fix-firecrawl-and-browser.md   # Firecrawl deps + browser sandbox fix
│   ├── install-mcp-chrome-dev-tools.md # Chrome DevTools MCP setup guide
│   └── openclaw_migration.md          # OpenClaw → Hermes migration steps
├── install_hermes.sh                  # One-liner: curl installer wrapper
└── install_firecrawl_docker.sh        # Self-hosted Firecrawl via Docker Compose
```

---

## ⚙️ Post-Installation Commands

```bash
hermes setup              # Re-run the full configuration wizard
hermes setup model        # Change model / provider
hermes config             # View current settings
hermes config edit        # Open config.yaml in your editor
hermes gateway start      # Launch messaging + cron gateway
hermes doctor             # Diagnose common issues
hermes update             # Pull latest version & bundled skills
```

---

## 📁 Where Files Live

After installation, everything is under `~/.hermes/`:

- **Config:** `~/.hermes/config.yaml`
- **API Keys:** `~/.hermes/.env`
- **Data:** `~/.hermes/cron/`, `~/.hermes/sessions/`, `~/.hermes/logs/`
- **Agent Code:** `~/.hermes/hermes-agent/`

---

## 📌 Notes

- This toolkit was built from a real-world installation on Ubuntu with a fully local LLM (no cloud API keys required for inference).
- All scripts and guides are tested but may need minor adjustments depending on your distro or hardware.
- Feel free to open an issue or submit a PR if you spot something outdated!
