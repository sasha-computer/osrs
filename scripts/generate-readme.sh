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
> This is my only downtime activity and I think it shows a different side of me.

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

## Current Goals

See [wintertodt-construction-plan.md](wintertodt-construction-plan.md) for the active game plan.

- [ ] 60 Woodcutting (currently 50)
- [ ] Complete Daddy's Home mini-quest
- [ ] 20 Construction (pre-Wintertodt)
- [ ] 85+ Firemaking via Wintertodt
- [ ] Tome of Fire
- [ ] ~70 Construction via Mahogany Homes

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
