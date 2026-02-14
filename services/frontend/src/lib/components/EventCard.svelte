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
          .map(([name, level]) => `${name} ${level}`)
          .join(", ");
      }
      case "LOOT": {
        const items = extra.items as Array<{
          name: string;
          quantity: number;
          priceEach: number;
        }>;
        if (!items) return "";
        const total = items.reduce(
          (sum, i) => sum + i.quantity * i.priceEach,
          0
        );
        return `${items.length} item${items.length !== 1 ? "s" : ""} (${total.toLocaleString()} gp)`;
      }
      case "QUEST":
        return (extra.questName as string) || "";
      case "DEATH": {
        const val = extra.valueLost as number;
        return val ? `Lost ${val.toLocaleString()} gp` : "";
      }
      case "COLLECTION":
        return (extra.itemName as string) || "";
      case "KILL_COUNT":
      case "SLAYER":
        return (extra.monster as string) || (extra.source as string) || "";
      case "PET":
        return "!!!";
      case "CLUE": {
        const tier = extra.clueType as string;
        const items = extra.items as Array<{ name: string }>;
        if (tier) return tier;
        if (items?.length) return items.map((i) => i.name).join(", ");
        return "";
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

  {#if event.message && event.type !== "LOGIN" && event.type !== "LOGOUT"}
    <p class="event-message">{event.message.replace(/%USERNAME%/g, event.player_name)}</p>
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

  .event-message {
    margin-top: 0.25rem;
    font-size: 0.85rem;
    color: var(--subtext0);
  }

  .event-screenshot {
    margin-top: 0.75rem;
    width: 100%;
    border-radius: calc(var(--radius) - 2px);
    border: 1px solid var(--surface0);
  }
</style>
