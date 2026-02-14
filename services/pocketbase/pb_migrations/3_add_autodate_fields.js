/// <reference path="../pb_data/types.d.ts" />

// Add created/updated autodate fields to events and snapshots
migrate((app) => {
  const collections = ["events", "snapshots"]
  for (const name of collections) {
    let collection = app.findCollectionByNameOrId(name)
    collection.fields.add(new Field({
      type: "autodate",
      name: "created",
      onCreate: true,
      onUpdate: false,
    }))
    collection.fields.add(new Field({
      type: "autodate",
      name: "updated",
      onCreate: true,
      onUpdate: true,
    }))
    app.save(collection)
  }
}, (app) => {
  // no-op
})
