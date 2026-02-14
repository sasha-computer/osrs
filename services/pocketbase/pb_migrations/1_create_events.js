/// <reference path="../pb_data/types.d.ts" />

// Events collection -- stores all Dink webhook events
migrate((app) => {
  let collection = new Collection({
    type: "base",
    name: "events",
    listRule: "",
    viewRule: "",
    createRule: null,
    updateRule: null,
    deleteRule: null,
    fields: [
      // Dink event type: DEATH, COLLECTION, LEVEL, LOOT, QUEST, SLAYER, KILL_COUNT, PET, CLUE, COMBAT_ACHIEVEMENT, DIARY, LOGIN, LOGOUT, etc.
      { name: "type", type: "text", required: true, max: 50 },
      // Player RSN
      { name: "player_name", type: "text", required: true, max: 50 },
      // NORMAL, IRONMAN, HARDCORE_IRONMAN, ULTIMATE_IRONMAN, GROUP_IRONMAN
      { name: "account_type", type: "text", max: 30 },
      // The full Dink "extra" object -- all event-specific data lives here
      { name: "extra", type: "json" },
      // Dink content message (human-readable summary)
      { name: "message", type: "text", max: 1000 },
      // Screenshot from Dink
      { name: "screenshot", type: "file", maxSelect: 1, maxSize: 10485760, mimeTypes: ["image/png", "image/jpeg"] },
      // World number
      { name: "world", type: "number" },
      // Region ID
      { name: "region_id", type: "number" },
    ],
    indexes: [
      "CREATE INDEX idx_events_type ON events (type)",
      "CREATE INDEX idx_events_player ON events (player_name)",
    ],
  })

  app.save(collection)
}, (app) => {
  let collection = app.findCollectionByNameOrId("events")
  app.delete(collection)
})
