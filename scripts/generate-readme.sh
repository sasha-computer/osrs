#!/bin/bash
# Generate README.md from fetched OSRS data
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."
DATA_DIR="$ROOT_DIR/data"
HISCORES="$DATA_DIR/hiscores.json"

if [ ! -f "$HISCORES" ]; then
  echo "No hiscores data found. Run fetch-stats.sh first."
  exit 1
fi

TIMESTAMP=$(date -u "+%Y-%m-%d %H:%M UTC")

# Extract skills using python3
read_skill() {
  python3 -c "
import json, sys
with open('$HISCORES') as f:
    data = json.load(f)
for s in data['skills']:
    if s['name'] == '$1':
        print(f\"{s['level']}|{s['xp']:,}\")
        break
"
}

# Build the skills table
SKILLS_TABLE=""
for skill in Overall Attack Defence Strength Hitpoints Ranged Prayer Magic Cooking Woodcutting Fletching Fishing Firemaking Crafting Smithing Mining Herblore Agility Thieving Slayer Farming Runecrafting Hunter Construction; do
  IFS='|' read -r level xp <<< "$(read_skill "$skill")"
  if [ "$skill" = "Overall" ]; then
    SKILLS_TABLE+="| **$skill** | **$level** | **$xp** |\n"
  elif [ "$level" != "1" ] && [ -n "$level" ] || [ "$skill" = "Hitpoints" ]; then
    SKILLS_TABLE+="| $skill | $level | $xp |\n"
  fi
done

# Extract combat level from WOM data if available
COMBAT_LVL="?"
if [ -f "$DATA_DIR/wom.json" ]; then
  COMBAT_LVL=$(python3 -c "
import json
with open('$DATA_DIR/wom.json') as f:
    data = json.load(f)
print(data.get('combatLevel', '?'))
" 2>/dev/null || echo "?")
fi

# Extract boss KCs (only non-zero)
BOSS_TABLE=""
if [ -f "$HISCORES" ]; then
  BOSS_TABLE=$(python3 -c "
import json
# These are actual bosses/minigames, not meta-activities
SKIP = {'Collections Logged', 'PvP Arena - Rank', 'League Points', 'Bounty Hunter - Hunter',
        'Bounty Hunter - Rogue', 'Clue Scrolls (all)', 'Clue Scrolls (beginner)',
        'Clue Scrolls (easy)', 'Clue Scrolls (medium)', 'Clue Scrolls (hard)',
        'Clue Scrolls (elite)', 'Clue Scrolls (master)', 'LMS - Rank', 'Soul Wars Zeal',
        'Rifts closed', 'Colosseum Glory'}
with open('$HISCORES') as f:
    data = json.load(f)
rows = []
for b in data.get('activities', []):
    if b.get('score', 0) > 0 and b['name'] not in SKIP:
        rows.append(f\"| {b['name']} | {b['score']:,} |\")
if rows:
    print('\n'.join(rows))
else:
    print('| *None yet -- time to start bossing* | - |')
" 2>/dev/null)
fi

cat > "$ROOT_DIR/README.md" << HEREDOC
# WoodFiveMan — Ironman Progress

> Old School RuneScape ironman account tracker. Updated manually or via script.
> After a childhood of video games, this is the one that stuck. Cosy vibes, no rush.

[![Wood Division Adventures #1](https://img.youtube.com/vi/SKdbje_ndE4/mqdefault.jpg)](https://www.youtube.com/watch?v=SKdbje_ndE4)

*Where the name comes from. [Wood Division Adventures](https://www.youtube.com/watch?v=SKdbje_ndE4) -- the rank below Bronze.*

**Account type:** Ironman
**Combat level:** $COMBAT_LVL
**Last updated:** $TIMESTAMP

## Skills

| Skill | Level | XP |
|-------|------:|---:|
$(echo -e "$SKILLS_TABLE")

## Boss Kill Counts

| Boss | KC |
|------|---:|
$BOSS_TABLE

## Quests

See **[quests.md](quests.md)** for the full quest log.

$(python3 -c "
import json, os
p = os.path.join('$DATA_DIR', 'wikisync.json')
if os.path.exists(p):
    with open(p) as f:
        data = json.load(f)
    quests = data.get('quests', {})
    done = len([v for v in quests.values() if v == 2])
    total = len(quests)
    pct = done / total if total else 0
    filled = int(pct * 20)
    bar = chr(9608) * filled + chr(9617) * (20 - filled)
    print(f'**{done}** / **{total}** completed')
    print()
    print(f'\`{bar}\` {pct:.0%}')
else:
    print('*Install WikiSync plugin and log in to track quests.*')
" 2>/dev/null)

## Current Goals

Synced from [Todoist](https://todoist.com) — ⚔️ OSRS board column. See [wintertodt-construction-plan.md](wintertodt-construction-plan.md) for the full game plan.

$(python3 -c "
import json, os
p = os.path.join('$DATA_DIR', 'todoist-osrs.json')
if os.path.exists(p):
    with open(p) as f:
        data = json.load(f)
    tasks = data.get('results', data) if isinstance(data, dict) else data
    # Priority mapping (Todoist API is inverted: 4=P1, 1=P4)
    icons = {4: '\U0001f534', 3: '\U0001f7e0', 2: '\U0001f535', 1: ''}
    for t in tasks:
        done = t.get('is_completed', False)
        check = 'x' if done else ' '
        icon = icons.get(t.get('priority', 1), '')
        desc = t.get('description', '')
        line = f'- [{check}] {icon} {t[\"content\"]}'
        if desc:
            # First line of description only
            first = desc.split(chr(10))[0].strip()
            if first:
                line += f' — *{first}*'
        print(line)
else:
    print('*Run fetch-todoist.sh to sync goals from Todoist.*')
" 2>/dev/null)

## Data Sources

| Source | What it provides | Status |
|--------|-----------------|--------|
| [OSRS Hiscores API](https://secure.runescape.com/m=hiscore_oldschool/index_lite.json?player=WoodFiveMan) | Skills, boss KCs, activities | Active |
| [Wise Old Man](https://wiseoldman.net/players/WoodFiveMan) | Historical gains, achievements, EHP | Active |
| [WikiSync](https://oldschool.runescape.wiki/w/RuneScape:WikiSync) | Quest completion, diary tasks | Needs RuneLite plugin |
| [Collection Log](https://github.com/osrsclog/runelite-plugin) | Collection log export | Needs RuneLite plugin |

## Setup: RuneLite Plugins to Install

To get full quest and collection log tracking, install these from the RuneLite Plugin Hub:

1. **WikiSync** — syncs quest completion + diary tasks to the OSRS Wiki. Once active, quest data becomes available at \`sync.runescape.wiki\`.
2. **Collection Log** — adds export to JSON for your collection log.
3. **Wise Old Man** — auto-updates your WOM profile on login/logout.
4. **Dink** — webhook notifications for drops, levels, quests, pets (can pipe to Discord or a custom endpoint).

## Updating

\`\`\`bash
# Fetch latest stats
./scripts/fetch-stats.sh

# Regenerate README
./scripts/generate-readme.sh
\`\`\`

---

*WoodFiveMan — an ironman stands alone.*
HEREDOC

echo "README.md generated."
