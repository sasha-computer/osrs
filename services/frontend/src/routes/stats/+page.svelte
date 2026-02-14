<script lang="ts">
  let { data } = $props();

  // Parse skills into a sorted table
  const skills = $derived(
    data.skills
      .filter(
        (s: { name: string; level: number }) =>
          s.name !== "Overall" && s.level > 1
      )
      .sort(
        (a: { level: number }, b: { level: number }) => b.level - a.level
      )
  );

  const overall = $derived(
    data.skills.find((s: { name: string }) => s.name === "Overall")
  );

  // Parse WOM data
  const wom = $derived(data.womData);
  const combatLevel = $derived(wom?.combatLevel || "?");
  const ehp = $derived(
    wom?.ehp != null ? (wom.ehp as number).toFixed(1) : "?"
  );
  const ttm = $derived(
    wom?.ttm != null ? (wom.ttm as number).toFixed(0) : "?"
  );

  // Parse diaries from WikiSync
  interface DiaryTier {
    complete: boolean;
    tasks: boolean[];
  }
  interface DiaryRegion {
    [tier: string]: DiaryTier;
  }

  const diaries = $derived(
    (data.wikisync?.achievement_diaries as Record<string, DiaryRegion>) || {}
  );

  const diaryTiers = ["Easy", "Medium", "Hard", "Elite"];

  function diaryStatus(
    region: DiaryRegion,
    tier: string
  ): { done: number; total: number } {
    const t = region[tier];
    if (!t) return { done: 0, total: 0 };
    return {
      done: t.tasks.filter(Boolean).length,
      total: t.tasks.length,
    };
  }

  // Collection log from WikiSync
  const clogItems = $derived(
    (data.wikisync?.collection_log as number[])?.length || 0
  );
  const clogTotal = $derived(
    (data.wikisync?.collectionLogItemCount as number) || 1697
  );
</script>

<svelte:head>
  <title>Stats -- WoodFiveMan</title>
</svelte:head>

<h1>Stats</h1>

<div class="stat-cards">
  <div class="stat-card">
    <span class="stat-label">Combat Level</span>
    <span class="stat-value">{combatLevel}</span>
  </div>
  <div class="stat-card">
    <span class="stat-label">Total Level</span>
    <span class="stat-value">{overall?.level || "?"}</span>
  </div>
  <div class="stat-card">
    <span class="stat-label">Total XP</span>
    <span class="stat-value"
      >{overall?.xp ? overall.xp.toLocaleString() : "?"}</span
    >
  </div>
  <div class="stat-card">
    <span class="stat-label">EHP</span>
    <span class="stat-value">{ehp}</span>
  </div>
  <div class="stat-card">
    <span class="stat-label">TTM</span>
    <span class="stat-value">{ttm}h</span>
  </div>
  <div class="stat-card">
    <span class="stat-label">Collection Log</span>
    <span class="stat-value">{clogItems} / {clogTotal}</span>
  </div>
</div>

<section class="section">
  <h2>All Skills</h2>
  <div class="skills-table">
    <div class="table-header">
      <span>Skill</span>
      <span>Level</span>
      <span>XP</span>
      <span>Rank</span>
    </div>
    {#each skills as skill}
      <div class="table-row">
        <span class="skill-name">{skill.name}</span>
        <span class="skill-level">{skill.level}</span>
        <span class="skill-xp">{skill.xp.toLocaleString()}</span>
        <span class="skill-rank"
          >{skill.rank > 0 ? `#${skill.rank.toLocaleString()}` : "-"}</span
        >
      </div>
    {/each}
  </div>
</section>

<section class="section">
  <h2>Achievement Diaries</h2>
  <div class="diary-grid">
    {#each Object.entries(diaries) as [region, tiers]}
      <div class="diary-region">
        <span class="diary-name">{region}</span>
        <div class="diary-tiers">
          {#each diaryTiers as tier}
            {@const s = diaryStatus(tiers, tier)}
            <span
              class="diary-tier"
              class:complete={s.done === s.total && s.total > 0}
              title="{tier}: {s.done}/{s.total}"
            >
              {tier[0]}
            </span>
          {/each}
        </div>
      </div>
    {/each}
  </div>
</section>

<style>
  h1 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 1.5rem;
  }

  .stat-cards {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
    gap: 0.75rem;
    margin-bottom: 2.5rem;
  }

  .stat-card {
    background: var(--mantle);
    border: 1px solid var(--surface0);
    border-radius: var(--radius);
    padding: 1rem;
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }

  .stat-label {
    font-size: 0.7rem;
    font-family: var(--font-mono);
    color: var(--overlay0);
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  .stat-value {
    font-family: var(--font-mono);
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--text);
  }

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

  .skills-table {
    display: flex;
    flex-direction: column;
    gap: 2px;
  }

  .table-header {
    display: grid;
    grid-template-columns: 1fr 60px 100px 90px;
    padding: 0.5rem 0.75rem;
    font-family: var(--font-mono);
    font-size: 0.7rem;
    color: var(--overlay0);
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  .table-row {
    display: grid;
    grid-template-columns: 1fr 60px 100px 90px;
    padding: 0.5rem 0.75rem;
    background: var(--mantle);
    border-radius: calc(var(--radius) / 2);
    font-size: 0.85rem;
  }

  .table-row:hover {
    background: var(--surface0);
  }

  .skill-name {
    color: var(--subtext1);
  }

  .skill-level {
    font-family: var(--font-mono);
    font-weight: 600;
    color: var(--text);
  }

  .skill-xp {
    font-family: var(--font-mono);
    font-size: 0.8rem;
    color: var(--overlay1);
  }

  .skill-rank {
    font-family: var(--font-mono);
    font-size: 0.8rem;
    color: var(--overlay0);
    text-align: right;
  }

  .diary-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 0.5rem;
  }

  .diary-region {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.5rem 0.75rem;
    background: var(--mantle);
    border-radius: var(--radius);
    border: 1px solid var(--surface0);
  }

  .diary-name {
    font-size: 0.8rem;
    color: var(--subtext0);
  }

  .diary-tiers {
    display: flex;
    gap: 0.25rem;
  }

  .diary-tier {
    width: 20px;
    height: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 3px;
    font-family: var(--font-mono);
    font-size: 0.6rem;
    font-weight: 700;
    background: var(--surface0);
    color: var(--overlay0);
  }

  .diary-tier.complete {
    background: var(--green);
    color: var(--crust);
  }
</style>
