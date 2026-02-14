<script lang="ts">
  import EventCard from "$lib/components/EventCard.svelte";
  import { EVENT_CONFIG, type GameEvent } from "$lib/pb";
  import { pb } from "$lib/pb";
  import { onMount } from "svelte";

  let { data } = $props();
  let events = $state(data.events as GameEvent[]);

  const eventTypes = Object.entries(EVENT_CONFIG)
    .filter(([k]) => k !== "LOGIN" && k !== "LOGOUT")
    .map(([key, config]) => ({
      key,
      ...config,
    }));

  onMount(() => {
    pb.collection("events").subscribe("*", (e) => {
      if (e.action === "create") {
        if (data.typeFilter && e.record.type !== data.typeFilter) return;
        events = [e.record as unknown as GameEvent, ...events].slice(0, 50);
      }
    });

    return () => {
      pb.collection("events").unsubscribe("*");
    };
  });
</script>

<svelte:head>
  <title>Timeline -- WoodFiveMan</title>
</svelte:head>

<h1>Timeline</h1>
<p class="total">{data.totalItems} events</p>

<div class="filters">
  <a href="/timeline" class:active={!data.typeFilter}>All</a>
  {#each eventTypes as type}
    <a
      href="/timeline?type={type.key}"
      class:active={data.typeFilter === type.key}
    >
      {type.icon} {type.label}
    </a>
  {/each}
</div>

{#if events.length === 0}
  <p class="empty">No events found.</p>
{:else}
  <div class="events-feed">
    {#each events as event (event.id)}
      <EventCard {event} />
    {/each}
  </div>
{/if}

{#if data.totalPages > 1}
  <div class="pagination">
    {#if data.page > 1}
      <a href="/timeline?page={data.page - 1}{data.typeFilter ? `&type=${data.typeFilter}` : ''}">
        &larr; Newer
      </a>
    {/if}
    <span class="page-info">Page {data.page} of {data.totalPages}</span>
    {#if data.page < data.totalPages}
      <a href="/timeline?page={data.page + 1}{data.typeFilter ? `&type=${data.typeFilter}` : ''}">
        Older &rarr;
      </a>
    {/if}
  </div>
{/if}

<style>
  h1 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 0.25rem;
  }

  .total {
    color: var(--overlay0);
    font-family: var(--font-mono);
    font-size: 0.8rem;
    margin-bottom: 1.5rem;
  }

  .filters {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    margin-bottom: 2rem;
  }

  .filters a {
    padding: 0.3rem 0.65rem;
    border-radius: var(--radius);
    font-size: 0.75rem;
    font-family: var(--font-mono);
    background: var(--surface0);
    color: var(--subtext0);
    transition: all 0.15s;
    white-space: nowrap;
  }

  .filters a:hover {
    background: var(--surface1);
    color: var(--text);
    text-decoration: none;
  }

  .filters a.active {
    background: var(--lavender);
    color: var(--crust);
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

  .pagination {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1.5rem;
    margin-top: 2rem;
    padding-top: 1.5rem;
    border-top: 1px solid var(--surface0);
  }

  .page-info {
    font-family: var(--font-mono);
    font-size: 0.8rem;
    color: var(--overlay0);
  }

  .pagination a {
    font-family: var(--font-mono);
    font-size: 0.85rem;
  }
</style>
