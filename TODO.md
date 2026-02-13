# TODO -- Taking This Way Too Far

Ideas for turning an ironman progress tracker into a full-blown personal project.

## Live Event Feed via Dink

[Dink](https://github.com/pajlads/DinkPlugin) is a RuneLite plugin that fires webhooks on in-game events -- level ups, quest completions, rare drops, deaths, collection log slots, boss kills, clue scrolls, combat achievements. It sends structured JSON with screenshots.

Right now it only points at Discord webhooks. But it also supports **custom web server URLs**. So:

- [ ] Build a tiny webhook receiver (Cloudflare Worker or Fly.io)
- [ ] Dink fires events to it in real-time as you play
- [ ] Receiver writes events to a database
- [ ] No more polling hiscores -- you get instant, granular data with timestamps and screenshots

### Dink event types we'd capture
- `LEVEL` -- skill level ups with XP
- `QUEST` -- quest completions
- `LOOT` -- item drops with value
- `COLLECTION` -- new collection log slots
- `DEATH` -- deaths with location
- `KILL_COUNT` -- boss KC milestones
- `COMBAT_ACHIEVEMENT` -- combat task completions
- `DIARY` -- achievement diary completions
- `PET` -- pet drops (the dream)
- `CLUE` -- clue scroll rewards

Each event includes player name, timestamp, and optionally a screenshot. This is the foundation for everything below.

## Database -- PocketBase

[PocketBase](https://pocketbase.io) over Supabase for this. It's a single Go binary with SQLite, auth, realtime subscriptions, file storage, and a REST API. Perfect for a personal project -- no managed service, no billing, self-host on Fly.io for ~$3/month.

- [ ] Deploy PocketBase on Fly.io (single machine, persistent volume)
- [ ] Schema: `events` table (type, timestamp, data JSON, screenshot URL), `snapshots` table (daily stats), `goals` table
- [ ] Dink webhook writes to PocketBase REST API
- [ ] GitHub Action writes daily snapshots for historical tracking
- [ ] PocketBase file storage for Dink screenshots

### Why PocketBase over Supabase
- Single binary, zero config, SQLite (no Postgres overhead for a one-user app)
- Built-in file storage (for screenshots)
- Realtime subscriptions out of the box (frontend can listen for live events)
- Self-hosted on Fly for pennies
- Good learning project -- you see everything, no magic

## Frontend

A personal dashboard site. Something minimal and cosy that matches the vibe.

- [ ] **SvelteKit** -- you already know Svelte, lightweight, SSR
- [ ] Deploy on Cloudflare Pages (free, fast)
- [ ] PocketBase JS SDK for data fetching + realtime

### Pages / Views

**Home**
- Current stats with skill icons
- Progress bars for active goals
- Recent activity feed (last 20 Dink events)
- Quest completion percentage with progress ring

**Timeline**
- Chronological feed of every event from Dink
- Screenshots inline (Dink sends these with events)
- Filterable by type (levels, drops, quests, deaths)
- This is the "adventure log" that OSRS doesn't give you

**Stats**
- XP gain charts over time (daily/weekly/monthly)
- Time to level estimates for each skill
- Wintertodt KC tracker with Tome of Fire probability calculator
- Boss KC tables once you start PvM

**Goals**
- Synced from Todoist or managed directly
- Visual progress (XP bars, quest requirements trees)
- Estimated time remaining based on recent XP rates

**Quest Map**
- All 211 quests, colored by status (done / in progress / locked / available)
- Click a quest to see requirements + what it unlocks
- Could pull requirement data from the OSRS Wiki API

### Design Vibes
- Dark, warm palette -- think RuneLite dark mode meets a cosy medieval tavern
- Pixel art touches (skill icons from the game, maybe a tiny WoodFiveMan character)
- Minimal, lots of whitespace, no clutter
- Berkeley Mono for any code/numbers
- Mobile-friendly (check progress on your phone while AFK at oaks)

## GitHub Repo Enhancements

- [ ] **Skill badges in README** -- `![Woodcutting](https://img.shields.io/badge/Woodcutting-50-green?logo=data:...)` with custom skill icons
- [ ] **XP progress bars** for active goals in README (ASCII or SVG)
- [ ] **Milestones log** -- `milestones.md` for notable moments (first boss kill, Tome of Fire, etc.)
- [ ] **Wintertodt calculator** -- estimated games to 85 FM, expected GP, Tome probability at current KC
- [ ] **Collection log page** -- obtained vs total per category once we have the data
- [ ] **Achievement diary tracker** -- `diaries.md` from WikiSync data

## The Full Pipeline

```
You play OSRS
    │
    ├─→ Dink fires webhook on every event
    │       │
    │       └─→ Cloudflare Worker / Fly.io receiver
    │               │
    │               ├─→ PocketBase (events, screenshots)
    │               └─→ Discord channel (optional, for fun)
    │
    ├─→ WikiSync uploads quests/diaries (automatic on login)
    │
    └─→ Hiscores update on logout

GitHub Action (daily 10:12am UTC)
    │
    ├─→ Fetches hiscores + WOM + WikiSync + Todoist
    ├─→ Regenerates README + quests.md
    └─→ Commits with descriptive message

Frontend (SvelteKit on Cloudflare Pages)
    │
    ├─→ PocketBase for live event data + screenshots
    ├─→ Realtime subscriptions for live updates
    └─→ Static data from GitHub repo / APIs
```

## Way Later / Dream Features

- [ ] **OBS overlay** -- if you ever stream, pull live stats into an overlay
- [ ] **Weekly recap email** -- automated summary of the week's gains, sent via Plunk or Resend
- [ ] **Hiscores race tracker** -- compare your progress against other ironmen at the same total level
- [ ] **AI play advisor** -- feed your stats + quest log to Claude API, get optimal next steps
- [ ] **3D print your character** -- export your gear setup and generate a 3D model (you have the printer)

---

*This is a RuneScape tracker. It does not need a database, a frontend, a webhook pipeline, or a 3D printer. But it's going to have all of them.*
