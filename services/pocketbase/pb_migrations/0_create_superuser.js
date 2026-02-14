/// <reference path="../pb_data/types.d.ts" />

// Create initial superuser from environment variables
migrate((app) => {
  const email = $os.getenv("PB_SUPERUSER_EMAIL")
  const password = $os.getenv("PB_SUPERUSER_PASSWORD")

  if (!email || !password) {
    console.log("PB_SUPERUSER_EMAIL or PB_SUPERUSER_PASSWORD not set, skipping superuser creation")
    return
  }

  // Check if superuser already exists
  try {
    app.findAuthRecordByEmail("_superusers", email)
    console.log("Superuser already exists, skipping")
    return
  } catch {
    // doesn't exist yet, create it
  }

  let superusers = app.findCollectionByNameOrId("_superusers")
  let record = new Record(superusers)
  record.set("email", email)
  record.set("password", password)
  app.save(record)
  console.log("Superuser created: " + email)
}, (app) => {
  // no-op
})
