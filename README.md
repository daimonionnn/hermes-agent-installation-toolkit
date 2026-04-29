Hermes-AI-Agent-Installation-Toolkit  

https://hermes-agent.nousresearch.com/



Here are steps for 100% offline self hosted linux installation

Tested on:
OS: Ubuntu 25
HW: AMD Ryzen 7 5700G, 64GB RAM, Nvidia 5090 32GB


I followed mainly this video how to install Hermes AI Agent:

https://www.youtube.com/watch?v=THA8Fov44QY


During setup I set all settings to be run loccaly.

Especially I set

- custom LLM model
    LM Studio, running on http://127.0.0.1:1234/v1  (OpenAI compatible)
    Right now I use on my nVidia 5090 32GB - Qwen3.6 27B Q4_M quant, context set to 200 000 tokens
    (using KV quantization Q8 or using Google Turboquant it can be set to max 262 000 tokens)

- Choose a provider:
    Local Browser (Free headless Chromium (nop API key needed))

- Search provider:
    Firecrawl self hosted  (you need to install Firecrawl docker self hosted before you continue with this step)
    run install_firecrawl_docker.sh

    Firecrawl self hosted MCP server in docker:
    https://github.com/firecrawl/firecrawl/blob/main/SELF_HOST.md

- Connected agent to Telegram (much better choice than WhasApp)

----------------------------------------------------------------------

After installtion I also Set up Chrome MCP dev tools - Hermes can access to your login seesions, like substack, gmail, X, etc. This is convenient, but dangerous. More secure access is to use RSS feeds and API keys (if web supports this).
You can also provide Hermes agent your current cookies/session values from browser session storage. 

Limitation is that sessions/cookies are usually valid for few days/hours so you need to repeat this step.


See details in:
Doc\fix-firecrawl-and-browser.md
Doc\install-mcp-chrome-dev-tools.md 
Doc\openclaw_migration.md

Just navigate you agent to these md files ant he will help you with setup and installation :)




After successfull installation and set up
------------------------------------------------

all your files are in ~/.hermes/:

   Settings:  /home/user/.hermes/config.yaml
   API Keys:  /home/user/.hermes/.env
   Data:      /home/user/.hermes/cron/, sessions/, logs/

────────────────────────────────────────────────────────────

📝 To edit your configuration:

   hermes setup          Re-run the full wizard
   hermes setup model    Change model/provider
   hermes setup terminal Change terminal backend
   hermes setup gateway  Configure messaging
   hermes setup tools    Configure tool providers

   hermes config         View current settings
   hermes config edit    Open config in your editor
   hermes config set <key> <value>
                          Set a specific value

   Or edit the files directly:
   nano /home/user/.hermes/config.yaml
   nano /home/user/.hermes/.env

────────────────────────────────────────────────────────────

🚀 Ready to go!

   hermes              Start chatting
   hermes gateway      Start messaging gateway
   hermes doctor       Check for issues


----------------------------------------------------------------------------


██╗  ██╗███████╗██████╗ ███╗   ███╗███████╗███████╗       █████╗  ██████╗ ███████╗███╗   ██╗████████╗
██║  ██║██╔════╝██╔══██╗████╗ ████║██╔════╝██╔════╝      ██╔══██╗██╔════╝ ██╔════╝████╗  ██║╚══██╔══╝
███████║█████╗  ██████╔╝██╔████╔██║█████╗  ███████╗█████╗███████║██║  ███╗█████╗  ██╔██╗ ██║   ██║
██╔══██║██╔══╝  ██╔══██╗██║╚██╔╝██║██╔══╝  ╚════██║╚════╝██╔══██║██║   ██║██╔══╝  ██║╚██╗██║   ██║
██║  ██║███████╗██║  ██║██║ ╚═╝ ██║███████╗███████║      ██║  ██║╚██████╔╝███████╗██║ ╚████║   ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝      ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝

╭─────────────────────────────────────────────────────────────────────────────────────────── Hermes Agent v0.11.0 (2026.4.23) · upstream df51ad79 ───────────────────────────────────────────────────────────────────────────────────────────╮
│                                   Available Tools                                                                                                                                                                                          │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⣀⣀⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   browser: browser_back, browser_click, ...                                                                                                                                                                │
│  ⠀⠀⠀⠀⠀⠀⢀⣠⣴⣾⣿⣿⣇⠸⣿⣿⠇⣸⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀   browser-cdp: browser_cdp, browser_dialog                                                                                                                                                                 │
│  ⠀⢀⣠⣴⣶⠿⠋⣩⡿⣿⡿⠻⣿⡇⢠⡄⢸⣿⠟⢿⣿⢿⣍⠙⠿⣶⣦⣄⡀⠀   clarify: clarify                                                                                                                                                                                         │
│  ⠀⠀⠉⠉⠁⠶⠟⠋⠀⠉⠀⢀⣈⣁⡈⢁⣈⣁⡀⠀⠉⠀⠙⠻⠶⠈⠉⠉⠀⠀   code_execution: execute_code                                                                                                                                                                             │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⡿⠛⢁⡈⠛⢿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   cronjob: cronjob                                                                                                                                                                                         │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⣿⣦⣤⣈⠁⢠⣴⣿⠿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   delegation: delegate_task                                                                                                                                                                                │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠻⢿⣿⣦⡉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   discord: discord                                                                                                                                                                                         │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢷⣦⣈⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   discord_admin: discord_admin                                                                                                                                                                             │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣴⠦⠈⠙⠿⣦⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   (and 16 more toolsets...)                                                                                                                                                                                │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣤⡈⠁⢤⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                                                                                                                                                                                                            │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠷⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   Available Skills                                                                                                                                                                                         │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠑⢶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   autonomous-ai-agents: claude-code, codex, hermes-agent, opencode                                                                                                                                         │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠁⢰⡆⠈⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   creative: architecture-diagram, ascii-art, ascii-video, b...                                                                                                                                             │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⠈⣡⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   data-science: jupyter-live-kernel                                                                                                                                                                        │
│  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀   devops: webhook-subscriptions                                                                                                                                                                            │
│                                   email: himalaya                                                                                                                                                                                          │
│    qwen3.6-27b · Nous Research    gaming: minecraft-modpack-server, pokemon-player                                                                                                                                                         │
│  /home/matt/.hermes/hermes-agent  general: dogfood, yuanbao                                                                                                                                                                                │
│  Session: 20260428_193426_0980e7  github: codebase-inspection, github-auth, github-code-r...                                                                                                                                               │
│                                   mcp: native-mcp                                                                                                                                                                                          │
│                                   media: gif-search, heartmula, songsee, spotify, youtub...                                                                                                                                                │
│                                   mlops: audiocraft-audio-generation, axolotl, dspy, eva...                                                                                                                                                │
│                                   note-taking: obsidian                                                                                                                                                                                    │
│                                   productivity: airtable, google-workspace, linear, maps, nano-...                                                                                                                                         │
│                                   red-teaming: godmode                                                                                                                                                                                     │
│                                   research: arxiv, blogwatcher, llm-wiki, polymarket, resea...                                                                                                                                             │
│                                   smart-home: openhue                                                                                                                                                                                      │
│                                   social-media: xurl                                                                                                                                                                                       │
│                                   software-development: debugging-hermes-tui-commands, hermes-agent-ski...                                                                                                                                 │
│                                                                                                                                                                                                                                            │
│                                   48 tools · 79 skills · /help for commands                                                                                                                                                                │
│                                   ⚠ 44 commits behind — run hermes update to update                                                                                                                                                        │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

Welcome to Hermes Agent! Type your message or /help for commands.
Heads up — an OpenClaw workspace was detected at ~/.openclaw/.
After migrating, the agent can still get confused and read that directory's config/memory instead of Hermes's.
Run `hermes claw cleanup` to archive it (rename → .openclaw.pre-migration). This tip only shows once; rerun it any time with `hermes claw cleanup`.
✦ Tip: hermes update syncs new bundled skills to ALL profiles automatically.




Next steps:
  hermes gateway start              # Start the service
  hermes gateway status             # Check status
  journalctl --user -u hermes-gateway -f  # View logs

✓ Systemd linger is enabled (service survives logout)
✓ Gateway service installed
✓ User service started
✓ Gateway started! Your bot is now online.


┌─────────────────────────────────────────────────────────┐
│              ✓ Installation Complete!                   │
└─────────────────────────────────────────────────────────┘


📁 Your files:

   Config:    /home/user/.hermes/config.yaml
   API Keys:  /home/user/.hermes/.env
   Data:      /home/user/.hermes/cron/, sessions/, logs/
   Code:      /home/user/.hermes/hermes-agent

─────────────────────────────────────────────────────────

🚀 Commands:

   hermes              Start chatting
   hermes setup        Configure API keys & settings
   hermes config       View/edit configuration
   hermes config edit  Open config in editor
   hermes gateway install Install gateway service (messaging + cron)
   hermes update       Update to latest version
