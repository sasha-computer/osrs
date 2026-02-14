<script lang="ts">
  import type { GameEvent } from "$lib/pb";
  import { getEventConfig, screenshotUrl, timeAgo } from "$lib/pb";

  let { event }: { event: GameEvent } = $props();

  const config = $derived(getEventConfig(event.type));
  const imgUrl = $derived(screenshotUrl(event));
  const detail = $derived(formatDetail(event));

  function formatDetail(e: GameEvent): string {
    const extra = e.extra;
    if (!extra) return "";

    switch (e.type) {
      case "LEVEL": {
        const skills = extra.levelledSkills as Record<string, number>;
        if (!skills) return "";
        return Object.entries(skills)
          .map(([name, level]) => `${name} to ${level}`)
          .join(", ");
      }
      case "LOOT": {
        const items = extra.items as Array<{
          name: string;
          quantity: number;
          priceEach: number;
        }>;
        const source = extra.source as string;
        if (!items) return source || "";
        const total = items.reduce(
          (sum, i) => sum + i.quantity * i.priceEach,
          0
        );
        const names = items.map((i) => i.quantity > 1 ? `${i.quantity}x ${i.name}` : i.name).join(", ");
        return `${names}${source ? ` from ${source}` : ""}${total > 0 ? ` (${total.toLocaleString()} gp)` : ""}`;
      }
      case "QUEST":
        return (extra.questName as string) || "";
      case "DEATH": {
        const killer = (extra.killerName as string) || "";
        const val = extra.valueLost as number;
        const parts = [];
        if (killer) parts.push(`Killed by ${killer}`);
        if (val) parts.push(`lost ${val.toLocaleString()} gp`);
        return parts.join(", ") || "Died";
      }
      case "COLLECTION":
        return (extra.itemName as string) || "";
      case "KILL_COUNT": {
        const boss = (extra.boss as string) || (extra.source as string) || "";
        const count = extra.count as number;
        return count ? `${boss} (KC ${count})` : boss;
      }
      case "SLAYER": {
        const task = (extra.slayerTask as string) || (extra.monster as string) || "";
        const points = extra.slayerPoints as string;
        return points ? `${task} (+${points} pts)` : task;
      }
      case "PET":
        return "!!!";
      case "CLUE": {
        const tier = extra.clueType as string;
        const items = extra.items as Array<{ name: string }>;
        const parts = [];
        if (tier) parts.push(tier);
        if (items?.length) parts.push(items.map((i) => i.name).join(", "));
        return parts.join(": ");
      }
      case "DIARY": {
        const area = (extra.area as string) || "";
        const difficulty = (extra.difficulty as string) || "";
        return `${area} ${difficulty}`.trim();
      }
      case "COMBAT_ACHIEVEMENT":
        return (extra.task as string) || "";
      case "CHAT": {
        const msg = (extra.message as string) || "";
        return msg;
      }
      default:
        return "";
    }
  }
</script>

<div class="event-card">
  <div class="event-header">
    <span class="event-icon">{config.icon}</span>
    <span class="event-type" style="color: {config.color}">{config.label}</span>
    <span class="event-time">{timeAgo(event.created)}</span>
  </div>

  {#if detail}
    <p class="event-detail">{detail}</p>
  {/if}

  {#if imgUrl}
    <img src={imgUrl} alt={event.message} class="event-screenshot" loading="lazy" />
  {/if}
</div>

<style>
  .event-card {
    padding: 1rem 1.25rem;
    background: var(--mantle);
    border-radius: var(--radius);
    border: 1px solid var(--surface0);
    transition: border-color 0.15s;
  }

  .event-card:hover {
    border-color: var(--surface1);
  }

  .event-header {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.85rem;
  }

  .event-icon {
    font-size: 1rem;
  }

  .event-type {
    font-family: var(--font-mono);
    font-weight: 600;
    font-size: 0.8rem;
    text-transform: uppercase;
    letter-spacing: 0.03em;
  }

  .event-time {
    margin-left: auto;
    color: var(--overlay0);
    font-family: var(--font-mono);
    font-size: 0.75rem;
  }

  .event-detail {
    margin-top: 0.5rem;
    font-size: 1rem;
    color: var(--text);
  }

  .event-screenshot {
    margin-top: 0.75rem;
    width: 100%;
    border-radius: calc(var(--radius) - 2px);
    border: 1px solid var(--surface0);
  }
</style>
