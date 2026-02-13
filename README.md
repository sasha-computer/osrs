# WoodFiveMan — Ironman Progress

> Old School RuneScape ironman account tracker. Updated manually or via script.
> This is my only downtime activity and I think it shows a different side of me.

**Account type:** Ironman
**Combat level:** 24
**Last updated:** 2026-02-13 13:39 UTC

## Skills

| Skill | Level | XP |
|-------|------:|---:|
| **Overall** | **411** | **915,327** |
| Attack | 9 | 1,072 |
| Defence | 11 | 1,546 |
| Strength | 25 | 8,058 |
| Hitpoints | 21 | 5,022 |
| Prayer | 18 | 3,682 |
| Magic | 29 | 12,314 |
| Cooking | 14 | 2,345 |
| Woodcutting | 50 | 101,932 |
| Fishing | 9 | 1,040 |
| Firemaking | 50 | 102,095 |
| Crafting | 8 | 817 |
| Smithing | 14 | 2,399 |
| Mining | 21 | 5,130 |
| Agility | 60 | 273,982 |
| Thieving | 63 | 393,868 |

## Boss Kill Counts

| Boss | KC |
|------|---:|
| *None yet -- time to start bossing* | - |

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

1. **WikiSync** — syncs quest completion + diary tasks to the OSRS Wiki. Once active, quest data becomes available at `sync.runescape.wiki`.
2. **Collection Log** — adds export to JSON for your collection log.
3. **Wise Old Man** — auto-updates your WOM profile on login/logout.
4. **Dink** — webhook notifications for drops, levels, quests, pets (can pipe to Discord or a custom endpoint).

## Updating

```bash
# Fetch latest stats
./scripts/fetch-stats.sh

# Regenerate README
./scripts/generate-readme.sh
```

---

*WoodFiveMan — an ironman stands alone.*
