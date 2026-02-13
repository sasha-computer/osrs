#!/bin/bash
# Fetch WoodFiveMan stats from OSRS Hiscores + Wise Old Man API
# Outputs JSON to data/stats.json and data/wom.json

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"
mkdir -p "$DATA_DIR"

PLAYER="WoodFiveMan"

echo "Fetching OSRS Hiscores for $PLAYER..."
curl -sf "https://secure.runescape.com/m=hiscore_oldschool/index_lite.json?player=$PLAYER" \
  | python3 -m json.tool > "$DATA_DIR/hiscores.json"

echo "Updating Wise Old Man for $PLAYER..."
# POST to update, then GET the full player data
curl -sf -X POST "https://api.wiseoldman.net/v2/players/$PLAYER" > /dev/null 2>&1 || true
sleep 2
curl -sf "https://api.wiseoldman.net/v2/players/$PLAYER" \
  | python3 -m json.tool > "$DATA_DIR/wom.json"

echo "Fetching WOM achievements progress..."
curl -sf "https://api.wiseoldman.net/v2/players/$PLAYER/achievements/progress" \
  | python3 -m json.tool > "$DATA_DIR/achievements.json"

echo "Fetching WikiSync data (quests, diaries, collection log)..."
curl -sf "https://sync.runescape.wiki/runelite/player/$PLAYER/STANDARD" \
  | python3 -m json.tool > "$DATA_DIR/wikisync.json" 2>/dev/null || echo "WikiSync: no data yet (install plugin + log in)"

echo "Done. Data saved to $DATA_DIR/"
