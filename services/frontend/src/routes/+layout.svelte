<script lang="ts">
  import "../app.css";

  let { children } = $props();
</script>

<div class="app">
  <header>
    <nav>
      <a href="/" class="logo">
        <span class="logo-icon">⚔️</span>
        <span class="logo-text">WoodFiveMan</span>
      </a>
      <div class="nav-links">
        <a href="/">Home</a>
        <a href="/timeline">Timeline</a>
        <a href="/stats">Stats</a>
      </div>
    </nav>
  </header>

  <main>
    {@render children()}
  </main>

  <footer>
    <p>Ironman btw</p>
  </footer>
</div>

<style>
  .app {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }

  header {
    border-bottom: 1px solid var(--surface0);
    padding: 1rem 1.5rem;
  }

  nav {
    max-width: var(--max-width);
    margin: 0 auto;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  .logo {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    text-decoration: none;
    font-size: 1.1rem;
  }

  .logo:hover {
    text-decoration: none;
  }

  .logo-icon {
    font-size: 1.3rem;
  }

  .logo-text {
    font-family: var(--font-mono);
    font-weight: 600;
    color: var(--text);
  }

  .nav-links {
    display: flex;
    gap: 1.5rem;
    font-size: 0.9rem;
  }

  .nav-links a {
    color: var(--subtext0);
    transition: color 0.15s;
  }

  .nav-links a:hover {
    color: var(--text);
    text-decoration: none;
  }

  main {
    flex: 1;
    max-width: var(--max-width);
    margin: 0 auto;
    padding: 2rem 1.5rem;
    width: 100%;
  }

  footer {
    border-top: 1px solid var(--surface0);
    padding: 1.5rem;
    text-align: center;
    color: var(--overlay0);
    font-size: 0.8rem;
    font-style: italic;
  }
</style>
