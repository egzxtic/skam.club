<template>
  <div class="strefy">
    <div class="strefy-header">
      <i class="fas fa-map-marked-alt"></i>
      <span>Dostępne strefy na serwerze</span>
    </div>
    <div class="strefy-list">
      <div class="strefa-card" v-for="(zone, idx) in strefy" :key="idx">
        <span class="status-dot" :class="zone.status"></span>
        <span class="status-label">{{ zone.statusLabel }}</span>
        <span class="strefa-title">
          <i class="fas fa-flag"></i>
          {{ zone.name }}
        </span>
        <span
          class="strefa-info"
          v-if="zone.status !== 'wolna'"
        >
          <span class="label">Przez</span>
          <span class="value">{{ zone.owner || 'Brak' }}</span>
        </span>
        <span
          class="strefa-info"
          v-if="zone.status !== 'wolna' && zone.status !== 'przejmowana'"
        >
          <span class="label">Aktywność</span>
          <span class="value">{{ zone.lastActivity }}</span>
        </span>
      </div>
      <div v-if="!strefy.length" class="empty-info">
        Brak dostępnych stref do wyświetlenia.
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    layerData: {
      type: Array,
      required: false,
      default: () => []
    }
  },
  computed: {
    strefy() {
      // jak zjebiesz to bedzie to XD nie ze w cn nie wierze
      const data = this.layerData && this.layerData.length ? this.layerData : [
        {
          name: 'Strefa Centralna',
          owner: 'Gang A',
          lastActivity: '2 godziny temu',
          status: 'przejeta'
        },
        {
          name: 'Strefa Północna',
          owner: 'Gang B',
          lastActivity: '10 minut temu',
          status: 'przejmowana'
        },
        {
          name: 'Strefa Południowa',
          owner: null,
          lastActivity: 'Brak danych',
          status: 'wolna'
        },
                {
          name: 'Strefa Południowa',
          owner: null,
          lastActivity: 'Brak danych',
          status: 'wolna'
        },
                {
          name: 'Strefa Południowa',
          owner: null,
          lastActivity: 'Brak danych',
          status: 'wolna'
        },
                {
          name: 'Strefa Południowa',
          owner: null,
          lastActivity: 'Brak danych',
          status: 'wolna'
        },
                {
          name: 'Strefa Południowa',
          owner: null,
          lastActivity: 'Brak danych',
          status: 'wolna'
        },
        
                {
          name: 'Strefa Południowa',
          owner: null,
          lastActivity: 'Brak danych',
          status: 'wolna'
        }
      ];
      return data.map(zone => ({
        ...zone,
        statusLabel:
          zone.status === 'przejeta'
            ? 'Przejeta'
            : zone.status === 'przejmowana'
            ? 'Przejmowana'
            : zone.status === 'wolna'
            ? 'Wolna'
            : ''
      }));
    }
  }
}
</script>

<style scoped>
.strefy {
  padding: 1vh;
  font-size: 1.3vh;
  display: flex;
  flex-direction: column;
  gap: 1vh;
}

.strefy-header {
  display: flex;
  align-items: center;
  gap: 1vh;
  font-size: 1.7vh;
  font-weight: 600;
  background: rgba(10, 10, 10, 0.92);
  border-radius: 1.2vh;
  padding: 1.2vh 2vh;
  border: solid 0.1vh rgba(32, 32, 32, 0.7);
  color: #fff;
  letter-spacing: 0.02em;
}

.strefy-header i {
  color: #fffbe7;
  font-size: 1.7vh;
}

.strefy-list {
  display: flex;
  flex-direction: column;
  gap: 1vh;
  width: 100%;
  max-height: 45vh;
  overflow-y: auto;
  padding-right: 0; 
  box-sizing: border-box;
}

/*
.strefy-list::-webkit-scrollbar {
  width: 0.8vh;
  background: rgba(30,30,30,0.7);
  border-radius: 1vh;
}
.strefy-list::-webkit-scrollbar-thumb {
  background: #444;
  border-radius: 1vh;
  border: 0.15vh solid #232323;
}
.strefy-list::-webkit-scrollbar-thumb:hover {
  background: #666;
}
.strefy-list {
  scrollbar-width: thin;
  scrollbar-color: #444 rgba(30,30,30,0.7);
}
*/

::-webkit-scrollbar {
  width: 0.8vh;
  background: rgba(30,30,30,0.7);
  border-radius: 1vh;
}
::-webkit-scrollbar-thumb {
  background: #444;
  border-radius: 1vh;
  border: 0.15vh solid #232323;
}
::-webkit-scrollbar-thumb:hover {
  background: #666;
}

body, html {
  scrollbar-width: thin;
  scrollbar-color: #444 rgba(30,30,30,0.7);
}

.strefa-card {
  width: 95%;
  min-height: 5vh;
  background: rgba(15, 15, 15, 0.98);
  border-radius: 1.2vh;
  border: solid 0.1vh rgba(32, 32, 32, 0.7);
  display: flex;
  align-items: center;
  gap: 1vh;
  box-shadow: 0 2px 8px 0 rgba(30,30,30,0.10);
  margin-bottom: 0.5vh;
  transition: border 0.18s;
  position: relative;
  overflow: hidden;
  padding: 0 2vh;
}

.strefa-card:hover {
  border-color: #232323;
}

.status-dot {
  width: 1.1vh;
  height: 1.1vh;
  border-radius: 50%;
  display: inline-block;
  margin-right: 0.7vh;
  box-shadow: 0 0 0 0 rgba(0,0,0,0.12);
  animation: pulse 1.7s infinite;
}
.status-label {
  font-size: 1.05vh;
  font-weight: 600;
  opacity: 0.85;
  letter-spacing: 0.01em;
  text-transform: uppercase;
  margin-right: 1.2vh;
}

.status-dot.przejeta {
  background: rgb(243, 44, 44);
  box-shadow: 0 0 0 0 rgba(243, 44, 44, 0.5);
  animation: pulse-red 1.7s infinite;
}
.status-dot.przejmowana {
  background: rgb(255, 153, 0);
  box-shadow: 0 0 0 0 rgba(255, 153, 0, 0.5);
  animation: pulse-orange 1.7s infinite;
}
.status-dot.wolna {
  background: rgb(76, 175, 80);
  box-shadow: 0 0 0 0 rgba(76, 175, 79, 0.5);
  animation: pulse-green 1.7s infinite;
}

@keyframes pulse-red {
  0% { box-shadow: 0 0 0 0 rgba(243, 44, 44, 0.5); }
  70% { box-shadow: 0 0 0 0.7vh rgba(243, 44, 44, 0.2); }
  100% { box-shadow: 0 0 0 0 rgba(243, 44, 44, 0.5); }
}
@keyframes pulse-orange {
  0% { box-shadow: 0 0 0 0 rgba(255, 153, 0, 0.5); }
  70% { box-shadow: 0 0 0 0.7vh rgba(255, 153, 0, 0.2); }
  100% { box-shadow: 0 0 0 0 rgba(255, 153, 0, 0.5); }
}
@keyframes pulse-green {
  0% { box-shadow: 0 0 0 0 rgba(76, 175, 79, 0.5); }
  70% { box-shadow: 0 0 0 0.7vh rgba(76, 175, 79, 0.2); }
  100% { box-shadow: 0 0 0 0 rgba(76, 175, 79, 0.5); }
}

.strefa-title {
  font-size: 1.2vh;
  font-weight: 700;
  color: #fff;
  display: flex;
  align-items: center;
  gap: 0.7vh;
  letter-spacing: 0.01em;
  margin-right: 2vh;
}

.strefa-title i {
  color: #fffbe7;
  font-size: 1.1vh;
}

.strefa-info {
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
}

.label {
  font-weight: 500;
  color: #fff;
  opacity: 0.5;
  font-size: 1.05vh;
  letter-spacing: 0.01em;
  margin-right: 0.5vh;
}

.value {
  background: rgba(39, 39, 39, 0.85);
  padding: 0.15vh 0.7vh;
  border-radius: 0.5vh;
  color: #FFF;
  font-weight: 500;
  font-size: 1.05vh;
  min-width: 6vh;
  text-align:center;
  opacity: 0.9;
}

.empty-info {
  color: #aaa;
  font-style: italic;
  padding: 2vh;
  width: 100%;
  text-align: center;
  background: rgba(20,20,20,0.7);
  border-radius: 1vh;
  margin-top: 2vh;
  font-size: 1.2vh;
  opacity: 0.7;
  letter-spacing: 0.01em;
}
</style>