import { Hono } from "hono";
import { logger } from "hono/logger";
import PocketBase from "pocketbase";

const app = new Hono();
app.use(logger());

const POCKETBASE_URL = process.env.POCKETBASE_URL || "http://localhost:8080";
const POCKETBASE_EMAIL = process.env.POCKETBASE_EMAIL || "";
const POCKETBASE_PASSWORD = process.env.POCKETBASE_PASSWORD || "";
const WEBHOOK_SECRET = process.env.WEBHOOK_SECRET || "";
const PLAYER_NAME = process.env.PLAYER_NAME || "WoodFiveMan";

let pb: PocketBase;

async function getPb(): Promise<PocketBase> {
  if (!pb || !pb.authStore.isValid) {
    pb = new PocketBase(POCKETBASE_URL);
    if (POCKETBASE_EMAIL && POCKETBASE_PASSWORD) {
      await pb
        .collection("_superusers")
        .authWithPassword(POCKETBASE_EMAIL, POCKETBASE_PASSWORD);
    }
  }
  return pb;
}

// Health check
app.get("/health", (c) => c.json({ status: "ok" }));

// Dink webhook receiver
// Dink sends multipart/form-data with:
//   - payload_json: the JSON body
//   - file: optional screenshot (image/png or image/jpeg)
app.post("/webhook/dink", async (c) => {
  // Optional: validate shared secret via query param or header
  if (WEBHOOK_SECRET) {
    const secret =
      c.req.query("secret") || c.req.header("X-Webhook-Secret") || "";
    if (secret !== WEBHOOK_SECRET) {
      return c.json({ error: "unauthorized" }, 401);
    }
  }

  try {
    const formData = await c.req.formData();
    const payloadRaw = formData.get("payload_json");

    if (!payloadRaw || typeof payloadRaw !== "string") {
      return c.json({ error: "missing payload_json" }, 400);
    }

    const payload = JSON.parse(payloadRaw);
    const screenshot = formData.get("file") as File | null;

    // Filter to only our player
    if (payload.playerName && payload.playerName !== PLAYER_NAME) {
      return c.json({ status: "ignored", reason: "wrong player" }, 200);
    }

    const client = await getPb();

    // Build the event record
    const eventFormData = new FormData();
    eventFormData.append("type", payload.type || "UNKNOWN");
    eventFormData.append("player_name", payload.playerName || PLAYER_NAME);
    eventFormData.append("account_type", payload.accountType || "");
    eventFormData.append("extra", JSON.stringify(payload.extra || {}));
    eventFormData.append("message", payload.content || "");
    if (payload.world) eventFormData.append("world", String(payload.world));
    if (payload.regionId)
      eventFormData.append("region_id", String(payload.regionId));

    // Attach screenshot if present
    if (screenshot && screenshot instanceof File) {
      eventFormData.append("screenshot", screenshot);
    }

    const record = await client.collection("events").create(eventFormData);

    console.log(
      `[${payload.type}] ${payload.playerName}: ${payload.content?.substring(0, 80) || "no message"}`
    );

    // If it's a LOGIN event, also save a snapshot from the metadata
    if (payload.type === "LOGIN" && payload.extra) {
      const extra = payload.extra;
      const snapshotData: Record<string, unknown> = {
        player_name: payload.playerName || PLAYER_NAME,
        source: "dink_login",
      };

      if (extra.skills) {
        snapshotData.skills = extra.skills;
      }
      if (extra.questCount) {
        snapshotData.quests = extra.questCount;
      }
      if (extra.collectionLog) {
        snapshotData.collection_log = extra.collectionLog;
      }
      if (extra.achievementDiary) {
        snapshotData.diaries = extra.achievementDiary;
      }
      if (extra.combatAchievementPoints) {
        snapshotData.combat_achievements = extra.combatAchievementPoints;
      }

      await client.collection("snapshots").create(snapshotData);
      console.log(`[SNAPSHOT] Saved login snapshot for ${payload.playerName}`);
    }

    return c.json({ status: "ok", id: record.id });
  } catch (err) {
    console.error("Webhook error:", err);
    return c.json({ error: "internal error" }, 500);
  }
});

const port = parseInt(process.env.PORT || "3000");
console.log(`Webhook receiver starting on port ${port}`);
console.log(`PocketBase URL: ${POCKETBASE_URL}`);
console.log(`Player filter: ${PLAYER_NAME}`);

export default {
  port,
  fetch: app.fetch,
};
