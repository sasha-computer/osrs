import type { PageServerLoad } from "./$types";

const PLAYER = "WoodFiveMan";
const PB_URL =
  process.env.POCKETBASE_URL ||
  "https://pocketbase-production-4cba.up.railway.app";

export const load: PageServerLoad = async ({ fetch }) => {
  // Fetch hiscores
  let skills: Array<{ name: string; level: number; xp: number }> = [];
  try {
    const res = await fetch(
      `https://secure.runescape.com/m=hiscore_oldschool/index_lite.json?player=${PLAYER}`
    );
    if (res.ok) {
      const data = await res.json();
      skills = data.skills || [];
    }
  } catch {
    // hiscores can be flaky
  }

  // Fetch recent events from PocketBase
  let events: unknown[] = [];
  try {
    const res = await fetch(
      `${PB_URL}/api/collections/events/records?sort=-created&perPage=20&filter=${encodeURIComponent("type!='LOGIN' && type!='LOGOUT'")}`
    );
    if (res.ok) {
      const data = await res.json();
      events = data.items || [];
    }
  } catch {
    // PocketBase might not be reachable during build
  }

  // Fetch quest count from WikiSync
  let questsDone = 0;
  let questsTotal = 211;
  try {
    const res = await fetch(
      `https://sync.runescape.wiki/runelite/player/${PLAYER}/STANDARD`
    );
    if (res.ok) {
      const data = await res.json();
      const quests = data.quests || {};
      questsDone = Object.values(quests).filter((v) => v === 2).length;
      questsTotal = Object.keys(quests).length;
    }
  } catch {
    // wikisync can be down
  }

  return {
    player: PLAYER,
    skills,
    events,
    quests: { done: questsDone, total: questsTotal },
  };
};
