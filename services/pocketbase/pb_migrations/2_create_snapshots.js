/// <reference path="../pb_data/types.d.ts" />

// Snapshots collection -- periodic stat snapshots for historical charting
migrate((app) => {
  let collection = new Collection({
    type: "base",
    name: "snapshots",
    listRule: "",
    viewRule: "",
    createRule: null,
    updateRule: null,
    deleteRule: null,
    fields: [
      { name: "player_name", type: "text", required: true, max: 50 },
      // Full skills data: { "Attack": { "level": 9, "xp": 1072 }, ... }
      { name: "skills", type: "json" },
      // Quest progress: { "completed": 20, "total": 211 }
      { name: "quests", type: "json" },
      // Boss kill counts
      { name: "bosses", type: "json" },
      // Collection log progress
      { name: "collection_log", type: "json" },
      // Achievement diaries
      { name: "diaries", type: "json" },
      // Combat achievements
      { name: "combat_achievements", type: "json" },
      // Source: "hiscores", "wom", "wikisync", "dink_login"
      { name: "source", type: "text", max: 30 },
    ],
    indexes: [
      "CREATE INDEX idx_snapshots_player ON snapshots (player_name)",
      "CREATE INDEX idx_snapshots_created ON snapshots (created)",
    ],
  })

  app.save(collection)
}, (app) => {
  let collection = app.findCollectionByNameOrId("snapshots")
  app.delete(collection)
})
