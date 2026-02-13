#!/bin/bash
# Fetch OSRS tasks from Todoist Board > ⚔️ OSRS section
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"
mkdir -p "$DATA_DIR"

TOKEN=$("$HOME/.pi/agent/skills/1password-vault/scripts/read-secret.sh" "Todoist API" credential 2>/dev/null)

# Board project ID: 6g2C97C558gXwR47
# OSRS section ID: 6g2CqcmPGVpH5rH7
curl -sf "https://api.todoist.com/api/v1/tasks?project_id=6g2C97C558gXwR47&section_id=6g2CqcmPGVpH5rH7" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  | python3 -m json.tool > "$DATA_DIR/todoist-osrs.json"

echo "Todoist OSRS tasks saved to $DATA_DIR/todoist-osrs.json"
