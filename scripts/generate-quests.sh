#!/bin/bash
# Generate quests.md from WikiSync data
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."
DATA_DIR="$ROOT_DIR/data"
WIKISYNC="$DATA_DIR/wikisync.json"

if [ ! -f "$WIKISYNC" ]; then
  echo "No WikiSync data found. Run fetch-stats.sh first (and install the WikiSync RuneLite plugin)."
  exit 1
fi

python3 -c "
import json, sys

with open('$WIKISYNC') as f:
    data = json.load(f)

quests = data.get('quests', {})
completed = sorted([q for q, v in quests.items() if v == 2])
in_progress = sorted([q for q, v in quests.items() if v == 1])
not_started = sorted([q for q, v in quests.items() if v == 0])
total = len(quests)

lines = []
lines.append('# Quest Log \u2014 WoodFiveMan')
lines.append('')
lines.append(f'**{len(completed)}** / **{total}** quests completed | **{len(in_progress)}** in progress')
lines.append('')

pct = len(completed) / total if total else 0
filled = int(pct * 20)
bar = '\u2588' * filled + '\u2591' * (20 - filled)
lines.append(f'\`{bar}\` {pct:.0%}')
lines.append('')

if in_progress:
    lines.append('## In Progress')
    lines.append('')
    for q in in_progress:
        lines.append(f'- \U0001f528 {q}')
    lines.append('')

lines.append('## Completed')
lines.append('')
for q in completed:
    lines.append(f'- [x] {q}')
lines.append('')

lines.append('## Not Started')
lines.append('')
for q in not_started:
    lines.append(f'- [ ] {q}')
lines.append('')

lines.append('---')
lines.append('')
lines.append('*Data from [WikiSync](https://oldschool.runescape.wiki/w/RuneScape:WikiSync). Log in with RuneLite to update.*')

print('\n'.join(lines))
" > "$ROOT_DIR/quests.md"

echo "quests.md generated."
