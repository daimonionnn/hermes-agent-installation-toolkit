#!/usr/bin/env bash
# chrome_remote_debug.sh
#
# Launches Chrome with remote debugging on port 9222 for interactive use.
# If the headless chrome-cdp systemd service is running it is stopped first,
# and automatically restarted when this script exits.

set -euo pipefail

PORT=9222
USER_DATA_DIR="$HOME/.config/google-chrome-ai-agent"
SERVICE="chrome-cdp.service"

# ── Stop the headless service if it holds the port ───────────────────────────
if systemctl is-active --quiet "$SERVICE" 2>/dev/null; then
    echo "==> Stopping headless $SERVICE to free port $PORT..."
    sudo systemctl stop "$SERVICE"
    # Restore the service when this script exits (Ctrl-C, close terminal, etc.)
    trap 'echo "==> Restarting headless $SERVICE..."; sudo systemctl start "$SERVICE"' EXIT
fi

# Wait up to 3 seconds for the port to be released
for i in 1 2 3; do
    ss -tlnp | grep -q ":$PORT " || break
    sleep 1
done

echo "==> Starting Chrome with remote debugging on port $PORT"
echo "    CDP endpoint: http://localhost:$PORT"
echo "    Close this terminal or press Ctrl-C to stop Chrome and restore the headless service."
echo ""

google-chrome \
    --remote-debugging-port=$PORT \
    --user-data-dir="$USER_DATA_DIR"

