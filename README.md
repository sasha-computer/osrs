# WoodFiveMan — Ironman Progress

> Old School RuneScape ironman account tracker. Updated manually or via script.
> After a childhood of video games, this is the one that stuck. Cosy vibes, no rush.

[![Wood Division Adventures #1](https://img.youtube.com/vi/SKdbje_ndE4/mqdefault.jpg)](https://www.youtube.com/watch?v=SKdbje_ndE4)

*Where the name comes from. [Wood Division Adventures](https://www.youtube.com/watch?v=SKdbje_ndE4) -- the rank below Bronze.*

**Account type:** Ironman
**Combat level:** 24
**Last updated:** 2026-02-13 14:20 UTC

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

## Quests

See **[quests.md](quests.md)** for the full quest log.

**18** / **211** completed

`█░░░░░░░░░░░░░░░░░░░` 9%

## Current Goals

Synced from [Todoist](https://todoist.com) — ⚔️ OSRS board column. See [wintertodt-construction-plan.md](wintertodt-construction-plan.md) for the full game plan.

- [ ] 🔴 Complete Daddy's Home mini-quest — *Speak to Marlo in NE Varrock (near Sawmill). Rewards: instant Construction 8, house unlock, free materials. No combat required.*
- [ ] 🟠 Pick up Collection Log book from The Collector (Varrock Museum) — *Ground floor near stairs. Free item. Open it in-game and click through tabs so RuneLite plugin syncs to collectionlog.net. You're right there for Daddy's Home anyway.*
- [ ] 🟠 Chop oaks to 60 Woodcutting (~4,600 logs) — *Seers' Village, oaks behind bank. BANK ALL LOGS. Currently level 50. ~15-17 hrs.*
- [ ] 🟠 Convert 200 oak logs to planks, train Construction to 20 — *Varrock Sawmill (250gp/plank). Build Oak Chairs then Oak Larders in POH (Rimmington). Need 50k GP.*
- [ ] 🟠 Grind Wintertodt to 85+ Firemaking (or Tome of Fire) — *Solo games, 13,500 pts each. Fletch kindling for bonus XP. Passive Con/WC/Fletch XP. Bank crate GP (~1M+ target). Currently FM 50.*
- [ ] 🔵 Convert remaining oak logs to planks at Sawmill (~1.1M GP) — *Use Wintertodt GP to fund. ~4,400 logs x 250gp = 1.1M GP.*
- [ ] 🔵 Grind Mahogany Homes with oak planks to ~70 Construction — *Novice Contracts (Falador/Varrock agents). ~2.5x XP per plank vs POH. Combined with Wintertodt passive Con XP should land 60-70.*

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
