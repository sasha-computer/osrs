import PocketBase from "pocketbase";

const POCKETBASE_URL =
  import.meta.env.VITE_POCKETBASE_URL ||
  "https://pocketbase-production-4cba.up.railway.app";

export const pb = new PocketBase(POCKETBASE_URL);

// Disable auto-cancellation so realtime + fetches don't interfere
pb.autoCancellation(false);

export interface GameEvent {
  id: string;
  type: string;
  player_name: string;
  account_type: string;
  extra: Record<string, unknown>;
  message: string;
  screenshot: string;
  world: number;
  region_id: number;
  created: string;
  updated: string;
  collectionId: string;
}

export interface Snapshot {
  id: string;
  player_name: string;
  skills: Record<string, unknown>;
  quests: Record<string, unknown>;
  bosses: Record<string, unknown>;
  collection_log: Record<string, unknown>;
  diaries: Record<string, unknown>;
  combat_achievements: Record<string, unknown>;
  source: string;
  created: string;
}

// Event type display config
export const EVENT_CONFIG: Record<
  string,
  { label: string; icon: string; color: string }
> = {
  LEVEL: { label: "Level Up", icon: "⬆️", color: "#a6e3a1" },
  QUEST: { label: "Quest", icon: "📜", color: "#f9e2af" },
  LOOT: { label: "Loot", icon: "💰", color: "#f5c2e7" },
  COLLECTION: { label: "Collection Log", icon: "📕", color: "#cba6f7" },
  DEATH: { label: "Death", icon: "💀", color: "#f38ba8" },
  KILL_COUNT: { label: "Boss Kill", icon: "⚔️", color: "#fab387" },
  PET: { label: "Pet!", icon: "🐾", color: "#f5c2e7" },
  CLUE: { label: "Clue Scroll", icon: "🗺️", color: "#89dceb" },
  COMBAT_ACHIEVEMENT: {
    label: "Combat Achievement",
    icon: "🏆",
    color: "#f9e2af",
  },
  DIARY: { label: "Achievement Diary", icon: "📓", color: "#a6e3a1" },
  SLAYER: { label: "Slayer Task", icon: "🗡️", color: "#eba0ac" },
  LOGIN: { label: "Logged In", icon: "🟢", color: "#a6adc8" },
  LOGOUT: { label: "Logged Out", icon: "🔴", color: "#a6adc8" },
  XP_MILESTONE: { label: "XP Milestone", icon: "✨", color: "#f9e2af" },
  CHAT: { label: "Chat", icon: "💬", color: "#a6adc8" },
};

export function getEventConfig(type: string) {
  return (
    EVENT_CONFIG[type] || { label: type, icon: "📌", color: "#a6adc8" }
  );
}

export function screenshotUrl(event: GameEvent): string | null {
  if (!event.screenshot) return null;
  return pb.files.getURL(event, event.screenshot);
}

export function timeAgo(dateStr: string): string {
  if (!dateStr) return "";
  const date = new Date(dateStr);
  if (isNaN(date.getTime())) return "";
  const now = new Date();
  const seconds = Math.floor((now.getTime() - date.getTime()) / 1000);

  if (seconds < 60) return "just now";
  if (seconds < 3600) return `${Math.floor(seconds / 60)}m ago`;
  if (seconds < 86400) return `${Math.floor(seconds / 3600)}h ago`;
  if (seconds < 604800) return `${Math.floor(seconds / 86400)}d ago`;
  return date.toLocaleDateString("en-GB", {
    day: "numeric",
    month: "short",
  });
}
