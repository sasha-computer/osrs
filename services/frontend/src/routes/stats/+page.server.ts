import type { PageServerLoad } from "./$types";

const PLAYER = "WoodFiveMan";

export const load: PageServerLoad = async ({ fetch }) => {
  // Fetch from Wise Old Man for historical data
  let womData: Record<string, unknown> | null = null;
  try {
    const res = await fetch(
      `https://api.wiseoldman.net/v2/players/${PLAYER}`
    );
    if (res.ok) {
      womData = await res.json();
    }
  } catch {
    // WOM down
  }

  // Fetch hiscores for current stats
  let skills: Array<{ name: string; level: number; xp: number; rank: number }> = [];
  try {
    const res = await fetch(
      `https://secure.runescape.com/m=hiscore_oldschool/index_lite.json?player=${PLAYER}`
    );
    if (res.ok) {
      const data = await res.json();
      skills = data.skills || [];
    }
  } catch {
    // hiscores flaky
  }

  // Fetch WikiSync for diaries + collection log
  let wikisync: Record<string, unknown> | null = null;
  try {
    const res = await fetch(
      `https://sync.runescape.wiki/runelite/player/${PLAYER}/STANDARD`
    );
    if (res.ok) {
      wikisync = await res.json();
    }
  } catch {
    // wikisync down
  }

  return {
    player: PLAYER,
    skills,
    womData,
    wikisync,
  };
};
