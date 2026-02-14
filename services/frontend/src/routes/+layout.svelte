<script lang="ts">
  import "../app.css";

  let { children } = $props();
</script>

<div class="app">
  <header>
    <nav>
      <div class="logo">
        <img src="/ironman.png" alt="Ironman" class="logo-icon" />
        <a href="https://wiseoldman.net/players/WoodFiveMan" target="_blank" rel="noopener" class="logo-text">WoodFiveMan</a>
        <span class="live-dot" id="live-dot" title="Realtime connected"></span>
      </div>
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
    height: 22px;
    width: auto;
    image-rendering: pixelated;
  }

  .live-dot {
    width: 7px;
    height: 7px;
    background: var(--green);
    border-radius: 50%;
    display: inline-block;
    animation: pulse 2s ease-in-out infinite;
  }

  @keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.4; }
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
