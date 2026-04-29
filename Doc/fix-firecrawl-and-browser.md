# Hermes Agent – Oprava Firecrawl a Browser na headless Linux

> **Dátum:** 28. apríl 2026  
> **Systém:** Ubuntu 24.04 LTS (headless VM)  
> **Problém:** Firecrawl a browser (agent-browser) nefungovali kvôli chýbajúcim systémovým knižnicám a sandbox restriction

---

## 🔥 Firecrawl – Oprava

### Príznaky chyby

```
Error: Could not find Chrome (ver. 131.0.6778.204).
```

Firecrawl vyžaduje Chrome/Chromium a množstvo systémových knižníc, ktoré na čistom Ubuntu serveri nie sú nainštalované.

### Krok 1: Inštalácia systémových závislostí

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

**Čo tieto balíky robia:**

| Balík | Účel |
|-------|------|
| `libatk1.0-0`, `libatk-bridge2.0-0` | Accessibility toolkit – potrebné pre Chrome UI |
| `libcups2` | CUPS printing library – Chrome ju loaduje pri štarte |
| `libxcomposite1` | Composite extension – X11 compositing |
| `libxss1` | X11 Screen Saver extension |
| `libxdamage1` | X11 damage extension – inkrementálne rendering |
| `libgbm1` | Generic Buffer Management – GPU acceleration |
| `libnss3` | Network Security Services – SSL/TLS certifikáty |
| `fonts-liberation` | Liberation fonts – základné fonty pre rendering |
| `libx11-xcb1` | X11 → XCB bridge |
| `libxkbcommon-x11-0` | Keyboard handling |
| `xdg-utils` | Desktop integration utilities |
| `fonts-noto-color-emoji` | Emoji fonty |

### Krok 2: Inštalácia Firecrawl browser dependencies

```bash
npx @firecrawl-ui/firecrawl-js@latest browser-with-system-deps install
```

Tento príkaz nainštaluje:
- Playwright Chromium browser
- Všetky system-level dependencies potrebné pre Chromium

### Krok 3: Overenie funkčnosti

```bash
# Firecrawl by mal teraz fungovať cez web_search a web_extract
```

---

## 🌐 Browser (agent-browser) – Oprava

### Príznaky chyby

```
[error] [browser] Browser crashed with exit code 1:
[0428/214921.989920:ERROR:zygote_host_impl_linux.cc(97)] No usable sandbox!
```

Chrome/Chromium v headless režime na Linuxe vyžaduje sandbox. Na systémoch bez nested virtualization (ako väčšina VPS) sandbox nefunguje.

### Riešenie: Vypnutie sandboxu

#### Metóda 1: Config súbor (Hlavné riešenie ✅)

**Súbor:** `~/.agent-browser/config.json`

```json
{
  "args": "--no-sandbox"
}
```

Tento config sa číta pri každom spustení agent-browser a pridá `--no-sandbox` flag do Chrome launch commandu.

#### Metóda 2: Environmentálna premenná (Alternatívne)

**Súbor:** `~/.hermes/.env`

```bash
AGENT_BROWSER_ARGS="--no-sandbox"
```

> **Pozor:** Pri zmene `.env` je potrebné restartovať Hermes gateway, aby sa prečítali nové premenné. Config súbor je spoľahlivejší.

### Čo robí `--no-sandbox`?

Normálne Chrome spúšťa child procesy v Linux sandboxe (namespace isolation, seccomp-bpf). Na headless serveroch/VPS:
- Nested namespaces sú často zakázané
- Seccomp profily môžu konfliktovať s containerizáciou
- Sandbox sa nedá inicializovať → Chrome crashne pri štarte

Flag `--no-sandbox` vypína túto ochranu. **Je to bezpečné** v kontexte agent-browser, pretože:
- Browser beží v izolovanom procese
- Nemá prístup k užívateľskému filesystemu mimo workspace
- Hermes ho beží s obmedzenými právami

---

## 📁 Štruktúra súborov

```
~/.hermes/
├── .env                          # AGENT_BROWSER_ARGS="--no-sandbox"
├── config.yaml                   # Hlavná konfigurácia Hermes Agent
└── ...

~/.agent-browser/
└── config.json                   # { "args": "--no-sandbox" }
```

---

## ✅ Overenie opravy

### Browser test

```python
# V Hermes agentovi:
browser_navigate(url="https://example.com")
# → Malo vrátiť snapshot stránky
```

### Firecrawl test

```python
# V Hermes agentovi:
web_search(query="test")
# → Malo vrátiť výsledky vyhľadávania
```

---

## 🔧 Rýchly rekapitulácia príkazov

```bash
# 1. Inštalácia systémových knižníc (pre Firecrawl)
sudo apt-get update && sudo apt-get install -y \
  libatk1.0-0 libatk-bridge2.0-0 libcups2 libxcomposite1 \
  libxss1 libxdamage1 libgbm1 libnss3 fonts-liberation \
  libx11-xcb1 libxkbcommon-x11-0 xdg-utils fonts-noto-color-emoji

# 2. Inštalácia Firecrawl browser deps
npx @firecrawl-ui/firecrawl-js@latest browser-with-system-deps install

# 3. Vypnutie sandboxu (pre browser)
mkdir -p ~/.agent-browser
echo '{"args": "--no-sandbox"}' > ~/.agent-browser/config.json

# 4. (Voliteľné) Pridanie do .env
echo 'AGENT_BROWSER_ARGS="--no-sandbox"' >> ~/.hermes/.env
```

---

## 📌 Poznámky

- **Firecrawl** sa používa interne pre `web_search` a `web_extract` – funguje ako backend pre vyhľadávanie a extrahovanie obsahu z web stránok
- **Browser** (`agent-browser`) sa používa pre interaktívne operácie: `browser_navigate`, `browser_click`, `browser_type`, `browser_snapshot`
- Na desktopovom systéme by sa `--no-sandbox` nepotreboval – sandbox funguje normálne
- Ak by sa niečo pokazilo po update, stačí skontrolovať či `~/.agent-browser/config.json` stále existuje
