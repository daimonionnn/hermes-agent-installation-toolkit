#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/firecrawl"

if ! command -v docker >/dev/null 2>&1; then
	echo "Docker is not installed or not in PATH."
	exit 1
fi

if docker compose version >/dev/null 2>&1; then
	COMPOSE_CMD=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
	COMPOSE_CMD=(docker-compose)
else
	echo "Docker Compose is not available (need 'docker compose' or 'docker-compose')."
	exit 1
fi

if [ ! -d "$REPO_DIR/.git" ]; then
	git clone https://github.com/firecrawl/firecrawl.git "$REPO_DIR"
fi

cd "$REPO_DIR"

cat > .env << 'EOF'
PORT=3002
HOST=0.0.0.0
USE_DB_AUTHENTICATION=false
BULL_AUTH_KEY=CHANGEME
EOF

sed -i 's|# image: ghcr.io/firecrawl/firecrawl|image: ghcr.io/firecrawl/firecrawl|' docker-compose.yaml
sed -i 's|  build: apps/api|  # build: apps/api|' docker-compose.yaml
sed -i 's|# image: ghcr.io/firecrawl/playwright-service:latest|image: ghcr.io/firecrawl/playwright-service:latest|' docker-compose.yaml
sed -i 's|    build: apps/playwright-service-ts|    # build: apps/playwright-service-ts|' docker-compose.yaml

"${COMPOSE_CMD[@]}" up -d