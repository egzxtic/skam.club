<template>
  <Transition name="menu">
    <div id="app" v-if="Visable">
      <div class="header">
        <div class="header-logo">
          <img src="./assets/typography.svg">
        </div>
        <div class="header-title">
          {{ $routers.title }}
          <div class="header-subtitle">{{ $routers.subtitle }}</div>
        </div>
      </div>

      <div class="main-container">
        <div class="sidebar">
          <div class="sidebar-nav">
            <RouterLink to="/" class="nav-item" :class="{ active: $route.path === '/' }">
              <span class="nav-icon"><i class="fas fa-home"></i></span> Panel
            </RouterLink>
            <RouterLink to="/strefy" class="nav-item" :class="{ active: $route.path === '/strefy' }">
              <span class="nav-icon"><i class="fas fa-map-marked-alt"></i></span> Strefy
            </RouterLink>
            <RouterLink to="/bank" class="nav-item" :class="{ active: $route.path === '/bank' }">
              <span class="nav-icon"><i class="fas fa-landmark"></i></span> Bank
            </RouterLink>
            <RouterLink to="/topki" class="nav-item" :class="{ active: $route.path === '/topki' }">
              <span class="nav-icon"><i class="fas fa-trophy"></i></span> Topka
            </RouterLink>
          </div>
          
          <div class="footer">
            <div class="test-mode">
              <i class="fas fa-crown"></i> Panel w fazie testowej
              <div class="test-mode-subtitle">Problemy prosimy składać na naszym oficjalnym serwerze discord - dc.skam.club</div>
            </div>
            <div class="esc-hint">
              <i class="fas fa-arrow-right"></i> Naciśnij ESC aby zamknąć
            </div>
          </div>
        </div>

      <main class="content">
        <div v-if="loading" class="loading-container">
          <div class="loading-spinner"></div>
          <span>Ładowanie danych...</span>
        </div>
        <router-view
          v-else
          :playerData="playerData"
          :rankingData="rankingData"
          :refreshData="fetchPlayerData"
          :layerData="layerData"
        />
      </main>
        </div>
      </div>
  </Transition>
</template>

<script>
export default {
  data() {
    return {
      Visable: false,
      loading: false,
      playerData: null,
      rankingData: null,
      layerData: [],
      pages: {
        Home: {
          title: 'Strona Główna',
          subtitle: 'Wszystkie informacje o twoim koncie znajdziesz tutaj'
        },
        Strefy: {
          title: 'Strefy',
          subtitle: 'Dostępne strefy na serwerze'
        },
        Bank: {
          title: 'Bank',
          subtitle: 'Twoje finanse i transakcje'
        },
        Topki: {
          title: 'Topka',
          subtitle: 'Ranking najlepszych graczy'
        }
      }
    }
  },
  computed: {
    $routers() {
      const $page = {
        '/': 'Home',
        '/strefy': 'Strefy',
        '/bank': 'Bank',
        '/topki': 'Topki'
      };
      const pageName = $page[this.$route.path] || 'Home';
      return this.pages[pageName];
    }
  },
  methods: {
    showMenu() {
      this.Visable = true;
      this.fetchPlayerData();
    },
    hideMenu() {
      this.Visable = false;
      fetch(`https://skam-playermenu/closePanel`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ closed: true })
      });
    },
    fetchPlayerData() {
      this.loading = true;
      fetch(`https://skam-playermenu/GetAllPlayerData`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
      })
        .then(res => res.json())
        .then(data => {
          this.playerData = data.playerData;
          this.rankingData = data.rankingData;
          this.layerData = data.layerData || [];
          this.loading = false;
        })
        .catch(err => {
          console.error('lol:', err);
          this.playerData = null;
          this.rankingData = null;
          this.layerData = [];
          this.loading = false;
        });
    }
  },
  mounted() {
    window.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        this.hideMenu();
      }
    });
    window.addEventListener('message', (event) => {
      if (event.data.type === 'showMenu') {
        this.showMenu();
      } else if (event.data.type === 'hideMenu') {
        this.hideMenu();
      }
    });
  }
}
</script>

<style>
:root {
  --color-black: #050505f2; /* var(--color-black); */
  --color-white: #FAFAFA; /* var(--color-white); */
  --color-border: #202020; /* var(--color-border); */
  --color-light: #999; /* var(--color-light); */
  --color-gray: #333; /* var(--color-gray); */
}
</style>

<style scoped>
* {
  font-family: "Red Hat Display", sans-serif;
  color: var(--color-white);
  user-select: none;
}

.fas, .fa, .far, .fal, .fab {
  font-family: "Font Awesome 5 Free" !important;
  font-weight: 700 !important;
  font-size: 1.4vh;
}

#app {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 115vh;
  height: 65vh;
  background: var(--color-black);
  border: solid 0.1vh var(--color-border);
  border-radius: 1vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  will-change: transform, opacity;
}

.header {
  display: flex;
  height: 7vh;
}

.header-logo {
  width: 18vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 2vh;
  font-size: 2vh;
  font-weight: bold;
}

.header-logo img {
  width: 11vh;
}

.header-title {
  padding: 1vh 2vh;
  font-weight: medium;
  font-size: 1.8vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.header-subtitle {
  font-size: 1.2vh;
  opacity: 0.6;
  font-weight: normal;
  margin-top: 0.2vh;
  color: var(--color-white);
}

.main-container {
  display: flex;
  flex: 1;
  height: calc(100% - 7vh);
}

.sidebar {
  width: 22vh;
  display: flex;
  flex-direction: column;
  position: relative;
  height: 100%;
}

.sidebar-nav {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2vh 1.5vh;
  flex-grow: 1;
}

.nav-item {
  display: flex;
  justify-content: center;
  align-items: center;
  color: var(--color-white);
  cursor: pointer;
  font-weight: 500;
  padding: 0.5vh 0;
  width: 13vh;
  text-align: center;
  transition: 
    background 0.18s cubic-bezier(.4,0,.2,1),
    color 0.18s cubic-bezier(.4,0,.2,1),
    box-shadow 0.18s cubic-bezier(.4,0,.2,1);
  margin: 0.5vh 0;
  text-decoration: none;
  font-size: 1.2vh;
  border-radius: 1vh;
  background-color: var(--color-black);
  box-shadow: none;
}

.nav-item:hover, .nav-item:focus-visible {
  color: var(--color-white);
  background: linear-gradient(90deg, #404040 0%, #202020 100%);
  outline: none;
}

.nav-item:hover .nav-icon i,
.nav-item:focus-visible .nav-icon i {
  color: var(--color-light);
  transition: color 0.18s cubic-bezier(.4,0,.2,1);
}

.active {
  color: var(--color-white);
  background: linear-gradient(90deg, #606060 0%, #303030 100%);
}

.active .nav-icon i {
  color: var(--color-white);
  margin-right: 0.3vh;
}

 .nav-icon i {
  color: var(--color-white);
  margin-right: 0.3vh;
}
.content {
  flex: 1;
  padding: 2vh;
  overflow-y: auto;
  background-color: var(--color-black);
}

.footer {
  padding: 1.5vh;
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  box-sizing: border-box;
}

.test-mode {
  background: var(--color-black);
  border-radius: 1.5vh;
  padding: 1.2vh 1.3vh 1.2vh 1.3vh;
  margin-bottom: 1vh;
  font-size: 1.1vh;
  font-weight: 500;
  position: relative;
  border: none;
  overflow: hidden;
}

.test-mode::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-radius: 1.5vh;
  padding: 0.18vh;
  background: var(--color-border);
  -webkit-mask:
    linear-gradient(var(--color-white) 0 0) content-box,
    linear-gradient(var(--color-white) 0 0);
  mask:
    linear-gradient(var(--color-white) 0 0) content-box,
    linear-gradient(var(--color-white) 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  pointer-events: none;
  z-index: 0;
}

.test-mode > * {
  position: relative;
  z-index: 1;
}

.test-mode {
  font-size: 1.1vh;
  color: var(--color-light);
}

.test-mode i {
  font-size: 1vh;
  color: var(--color-light);
}

.test-mode-subtitle {
  margin-top: 0.5vh;
  font-size: 0.95vh;
  line-height: 1.4;
  color: var(--color-light);
  font-weight: 400;
}

.esc-hint {
  font-size: 1vh;
  color: var(--color-gray);
  text-align: center;
  padding-top: 0.5vh;
}

.esc-hint i {
  margin-right: 0.5vh;
  font-size: 0.8vh;
  color: var(--color-gray);
}

.loading-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  flex-direction: column;
}

.loading-container span {
  font-size: 1.4vh;
  color: var(--color-white);
  margin-top: 2vh;
}

.loading-spinner {
  width: 5vh;
  height: 5vh;
  border: 0.3vh solid var(--color-border);
  border-top: 0.3vh solid var(--color-white);
  border-radius: 50%;
  animation: spin 1s linear infinite, pulse 2s ease-in-out infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@keyframes pulse {
  0% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.4); }
  70% { box-shadow: 0 0 0 1vh rgba(255, 255, 255, 0); }
  100% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0); }
}

.menu-enter-active,
.menu-leave-active {
  transition: all 0.3s ease-out;
}

.menu-enter-from {
  opacity: 0;
  transform: translate(-50%, -45%) scale(0.95);
}

.menu-leave-to {
  opacity: 0;
  transform: translate(-50%, -55%) scale(0.95);
}

.menu-enter-to,
.menu-leave-from {
  opacity: 1;
  transform: translate(-50%, -50%) scale(1);
}
</style>