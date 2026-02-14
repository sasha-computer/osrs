<script lang="ts">
  import SkillsGrid from "$lib/components/SkillsGrid.svelte";
  import EventCard from "$lib/components/EventCard.svelte";
  import { pb, type GameEvent } from "$lib/pb";
  import { onMount } from "svelte";

  let { data } = $props();
  let events = $state(data.events as GameEvent[]);

  onMount(() => {
    pb.collection("events").subscribe("*", (e) => {
      if (e.action === "create") {
        if (e.record.type === "LOGIN" || e.record.type === "LOGOUT") return;
        events = [e.record as unknown as GameEvent, ...events].slice(0, 50);
      }
    });

    return () => {
      pb.collection("events").unsubscribe("*");
    };
  });

  const questPercent = $derived(
    data.quests.total > 0
      ? Math.round((data.quests.done / data.quests.total) * 100)
      : 0
  );
</script>

<svelte:head>
  <title>WoodFiveMan -- Ironman Progress</title>
</svelte:head>

<section class="section">
  <h2>Skills</h2>
  <SkillsGrid skills={data.skills} />
</section>

<section class="section">
  <div class="section-header">
    <h2>Quests</h2>
    <span class="quest-count">{data.quests.done} / {data.quests.total}</span>
  </div>
  <div class="progress-bar">
    <div class="progress-fill" style="width: {questPercent}%"></div>
  </div>
  <p class="progress-label">{questPercent}%</p>
</section>

<section class="section">
  <h2>Recent Activity</h2>
  {#if events.length === 0}
    <p class="empty">No events yet. Waiting for Dink to send data...</p>
  {:else}
    <div class="events-feed">
      {#each events as event (event.id)}
        <EventCard {event} />
      {/each}
    </div>
  {/if}
</section>

<style>
  .section {
    margin-bottom: 2.5rem;
  }

  h2 {
    font-size: 1rem;
    font-weight: 600;
    color: var(--subtext0);
    text-transform: uppercase;
    letter-spacing: 0.05em;
    font-family: var(--font-mono);
    margin-bottom: 1rem;
  }

  .section-header {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
  }

  .quest-count {
    font-family: var(--font-mono);
    font-size: 0.85rem;
    color: var(--overlay1);
  }

  .progress-bar {
    height: 6px;
    background: var(--surface0);
    border-radius: 3px;
    overflow: hidden;
  }

  .progress-fill {
    height: 100%;
    background: var(--green);
    border-radius: 3px;
    transition: width 0.5s ease;
  }

  .progress-label {
    font-family: var(--font-mono);
    font-size: 0.75rem;
    color: var(--overlay0);
    margin-top: 0.35rem;
  }

  .events-feed {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
  }

  .empty {
    color: var(--overlay0);
    font-style: italic;
    padding: 2rem 0;
  }
</style>
