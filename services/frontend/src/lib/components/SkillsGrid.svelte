<script lang="ts">
  interface Skill {
    name: string;
    level: number;
    xp: number;
  }

  let { skills }: { skills: Skill[] } = $props();

  // Filter out Overall and unranked skills, sort by level desc
  const displaySkills = $derived(
    skills
      .filter((s) => s.name !== "Overall" && s.level > 1)
      .sort((a, b) => b.level - a.level)
  );

  const overall = $derived(skills.find((s) => s.name === "Overall"));
</script>

{#if overall}
  <div class="overall">
    <span class="overall-label">Total Level</span>
    <span class="overall-value">{overall.level}</span>
    <span class="overall-xp">{overall.xp.toLocaleString()} XP</span>
  </div>
{/if}

<div class="skills-grid">
  {#each displaySkills as skill}
    <div class="skill">
      <span class="skill-name">{skill.name}</span>
      <span class="skill-level">{skill.level}</span>
    </div>
  {/each}
</div>

<style>
  .overall {
    display: flex;
    align-items: baseline;
    gap: 0.75rem;
    margin-bottom: 1.5rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid var(--surface0);
  }

  .overall-label {
    color: var(--subtext0);
    font-size: 0.85rem;
  }

  .overall-value {
    font-family: var(--font-mono);
    font-size: 2rem;
    font-weight: 700;
    color: var(--text);
    line-height: 1;
  }

  .overall-xp {
    font-family: var(--font-mono);
    font-size: 0.8rem;
    color: var(--overlay1);
  }

  .skills-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
    gap: 0.5rem;
  }

  .skill {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.5rem 0.75rem;
    background: var(--mantle);
    border-radius: var(--radius);
    border: 1px solid var(--surface0);
  }

  .skill-name {
    font-size: 0.8rem;
    color: var(--subtext0);
  }

  .skill-level {
    font-family: var(--font-mono);
    font-weight: 600;
    font-size: 0.9rem;
    color: var(--text);
  }
</style>
