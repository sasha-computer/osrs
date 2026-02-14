# TODO -- Taking This Way Too Far

An ironman progress tracker that became a full-blown personal project.

## What's Done

### Data Pipeline
- [x] **OSRS Hiscores** -- fetched via API (skills, levels, XP, boss KC)
- [x] **Wise Old Man** -- XP history, gains over time, EHP, TTM
- [x] **WikiSync** -- quests (20/211), achievement diaries (task-level detail), levels, collection log (16 items synced)
- [x] **Todoist** -- OSRS goals/tasks synced
- [x] **GitHub Action** -- daily cron (10:12 UTC) fetches all data, regenerates README + quests.md, commits with descriptive diffs

### Dink Webhook Pipeline
- [x] **Dink plugin** installed and configured in RuneLite -- all notifiers enabled (levels, quests, loot, collection log, deaths, boss KC, pets, clues, combat achievements, diaries, slayer, chat)
- [x] **Screenshots** enabled for all event types
- [x] **Webhook receiver** on Railway (Bun + Hono) -- accepts Dink multipart/form-data, parses `payload_json` + screenshot, writes to PocketBase
- [x] **Webhook secret** for auth via query param
- [x] **Player filter** -- only accepts events from WoodFiveMan
- [x] **LOGIN events** also save a full stat snapshot to the snapshots collection
- [x] **RuneLite cloud sync** -- settings sync across devices (PC + Steam Deck)
- [x] **`::TriggerDink`** chat command for manual testing

### PocketBase
- [x] **Deployed on Railway** with persistent volume at `/pb_data`
- [x] **Schema**: `events` (type, player_name, account_type, extra JSON, message, screenshot, world, region_id) + `snapshots` (skills, quests, bosses, collection_log, diaries, combat_achievements, source)
- [x] **Superuser** created via migration from env vars
- [x] **Autodate fields** (created/updated) added to both collections
- [x] **File storage** for Dink screenshots
- [x] **Realtime subscriptions** enabled (frontend subscribes for live updates)
- [x] **Public read access** on events + snapshots (no auth needed to view)

### Frontend
- [x] **SvelteKit** on Railway (adapter-node, Bun runtime)
- [x] **Catppuccin Mocha** dark theme, Berkeley Mono for numbers, Bookerly for prose
- [x] **Home page** -- skills grid from hiscores, quest progress bar from WikiSync, recent activity feed from PocketBase
- [x] **Timeline page** -- all events chronologically, filterable by type, pagination, realtime updates
- [x] **Stats page** -- combat level, total level, total XP, EHP, TTM from WOM; full skills table with rank; achievement diaries grid; collection log count
- [x] **Event cards** -- type icon + color, clean detail line (no redundant messages), screenshots inline, relative timestamps
- [x] **Realtime** -- green dot in navbar, new events appear live without refresh
- [x] **Ironman helmet** logo linking to Wise Old Man profile

### Infrastructure
- [x] **Railway project** `osrs-tracker` with 3 services, all in `europe-west4`
  - PocketBase: `pocketbase-production-4cba.up.railway.app`
  - Webhook: `webhook-production-656f.up.railway.app`
  - Frontend: `frontend-production-c941.up.railway.app`

## The Pipeline

```
You play OSRS
    │
    ├─→ Dink fires webhook on every event
    │       │
    │       └─→ Railway webhook receiver (Bun + Hono)
    │               │
    │               └─→ PocketBase (events + screenshots)
    │                       │
    │                       └─→ Realtime subscription
    │                               │
    │                               └─→ SvelteKit frontend (live update)
    │
    ├─→ WikiSync uploads quests/diaries/clog (automatic on login)
    │
    └─→ Hiscores update on logout

GitHub Action (daily 10:12am UTC)
    │
    ├─→ Fetches hiscores + WOM + WikiSync + Todoist
    ├─→ Regenerates README + quests.md
    └─→ Commits with descriptive message
```

## Next Up

### Frontend Polish
- [ ] **OSRS skill icons** -- use actual game sprites instead of plain text in the skills grid
- [ ] **Mobile layout** -- check it works on phone (check progress while AFK at oaks)
- [ ] **Active nav link highlighting** -- show which page you're on
- [ ] **Empty states** -- nicer messaging when no events of a type exist
- [ ] **Event grouping** -- group events by day in the timeline with date headers
- [ ] **Relative time auto-refresh** -- update "5m ago" without full page reload

### Data Improvements
- [ ] **Daily snapshots from GitHub Action** -- push hiscores/WOM data to PocketBase snapshots collection alongside the git commits
- [ ] **XP gain charts** -- chart XP over time using snapshot data (daily/weekly/monthly)
- [ ] **Collection log breakdown** -- show obtained vs total per category from WikiSync data
- [ ] **Boss KC tracking** -- table with KC + personal bests once PvM starts
- [ ] **Quest requirements tree** -- click a quest to see what you need + what it unlocks (OSRS Wiki API)

### Goals Page
- [ ] **Todoist integration** -- pull OSRS goals and show visual progress
- [ ] **XP-based progress bars** -- estimate time remaining based on recent XP rates
- [ ] **Quest requirements checker** -- highlight quests you can do now vs what's locked

### Custom Domain
- [ ] **Cloudflare DNS** -- point a subdomain at the Railway frontend

### Notifications
- [ ] **Discord channel** -- optionally forward Dink events to a Discord webhook too
- [ ] **Weekly recap** -- automated summary of the week's gains

## Dream Features

- [ ] **OBS overlay** -- if you ever stream, pull live stats into an overlay
- [ ] **Hiscores race tracker** -- compare progress against other ironmen at the same total level
- [ ] **AI play advisor** -- feed stats + quest log to Claude API, get optimal next steps
- [ ] **Wintertodt calculator** -- estimated games to target FM level, expected GP, Tome probability
- [ ] **3D print your character** -- export gear setup and generate a 3D model (you have the printer)

---

*This is a RuneScape tracker. It does not need a database, a frontend, a webhook pipeline, or a 3D printer. But it's going to have all of them.*
