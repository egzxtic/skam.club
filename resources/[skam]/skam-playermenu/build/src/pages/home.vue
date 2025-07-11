<template>
  <div>
    <Load v-if="!playerData" />
    <div class="home" v-else>
      <div class="profil">
        <div class="profil-header">
          <img class="avatar" :src="playerData.avatar" />
          <div class="info">
            <div class="nick">{{ playerData.name }}</div>
            <div class="line"><span class="label">DiscordID</span> <span class="value">{{ playerData.discordId }}</span></div>
            <div class="line"><span class="label">RANGA</span> <span class="tag">{{ playerData.rank }}</span></div>
            <div class="line"><span class="label">ORGANIZACJA</span> <span class="tag">{{ playerData.organization }}</span></div>
          </div>
        </div>

        <hr class="divider" />

        <div class="grid">
          <div class="stat"><div><i class="fas fa-crosshairs"></i> Zabójstwa</div><span class="bar">{{ playerData.kills }}</span></div>
          <div class="stat"><div><i class="fas fa-skull"></i> Śmierci</div><span class="bar">{{ playerData.deaths }}</span></div>
          <div class="stat"><div><i class="fas fa-user-friends"></i> K/D</div><span class="bar">{{ playerData.kd }}</span></div>
          <div class="stat"><div><i class="fas fa-trophy"></i> Ranking</div><span class="bar">{{ playerData.rankingPoints }} pkt.</span></div>
          <div class="stat wkrótce">WKRÓTCE..</div>
          <div class="stat wkrótce">WKRÓTCE..</div>
        </div>
      </div>

      <div class="prawa">
        <div class="grid2">
          <div class="stat"><div><i class="fas fa-clock"></i> Czas gry</div><span class="bar">{{ playerData.playTime }}</span></div>
          <div class="stat"><div><i class="fas fa-coins"></i> Coinsy</div><span class="bar">{{ playerData.coins }} SC</span></div>
          <div class="stat"><div><i class="fas fa-chart-line"></i> Pozycja w rankingu</div><span class="bar">{{ playerData.rankingPosition }}</span></div>
          <div class="stat"><div><i class="fas fa-flag"></i> Przejęte strefy</div><span class="bar">{{ playerData.capturedZones }}</span></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Load from '../components/load.vue';
export default {
  components: { Load },
  props: {
    playerData: Object
  }
}
</script>


<style scoped>
.home {
  display: flex;
  gap: 2vh;
  padding: 2vh;
  font-size: 1.4vh;
}

.profil,
.prawa {
  background: rgba(5, 5, 5, 0.95);
  border-radius: 2vh;
  border: solid 0.1vh rgba(32, 32, 32, 1);
  padding: 2vh;
  display: flex;
  flex-direction: column;
  width: 100%;
  max-width: 45vw;
}

.profil > .profil-header {
  display: flex;
  align-items: center;
  gap: 2vh;
}

.profil-header > .avatar {
  width: 8vh;
  height: 8vh;
  border-radius: 1.5vh;
  border: solid 0.2vh rgba(250, 250, 250, 1);
  object-fit: cover;
}

.profil-header > .info {
  display: flex;
  flex-direction: column;
  gap: 0.3vh;
}

.info > .nick {
  font-size: 1.5vh;
  font-weight: bold;
  background: linear-gradient(90deg, var(--color-white) 0%, var(--color-gray) 30%, var(--color-light) 50%, var(--color-gray) 70%, var(--color-white) 100%);
  background-size: 400% auto;
  background-position: left center;
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  animation: shine 2.5s linear infinite
}

@keyframes shine {
  0% {
    background-position: 0% 50%;
  }
  100% {
    background-position: 100% 50%;
  }
}

.info > .line {
  display: flex;
  gap: 1vh;
  font-size: 1.3vh;
  color: #ccc;
}

.line > .label {
  font-weight: bold;
  color: #FFF;
  font-size: 1.1vh;
}

.line > .tag, 
.line > .value {
  background: rgba(51, 51, 51, 1);
  padding: 0.2vh 0.8vh;
  border-radius: 0.5vh;
  color: #FFF;
  font-weight: 500;
  font-size: 1.1vh;
}

.divider {
  border: none;
  border-top: 0.1vh solid rgb(59, 59, 59);
  margin: 2vh 0;
}

.profil > .grid,
.prawa > .grid2 {
  display: grid;
  gap: 1.5vh;
}

.profil > .grid {
  flex-direction: row;
  grid-template-columns: repeat(2, 1fr);
}

.prawa > .grid2 {
  grid-template-columns: repeat(1, 3fr);
}

.grid > .stat,
.grid2 > .stat {
  background: rgba(5, 5, 5, 0.95);
  border: solid 0.1vh rgba(32, 32, 32, 1);
  padding: 1.3vh;
  border-radius: 1.5vh;
  color: rgb(255, 255, 255);
  display: flex;
  flex-direction: column;
  gap: 0.5vh;
  font-weight: 500;
}

.stat {
  position: relative;
}

.stat > i {
  margin-right: 0.5vh;
  opacity: 0.8;
  display: inline-block;
  font-size: 1.1vh;
  text-align: center;
}

.stat > .bar {
  background: rgba(51, 51, 51, 1);
  padding: 0.4vh 0.8vh;
  border-radius: 1vh;
  text-align: start;
  margin-top: 0.5vh;
  font-size: 1.2vh;
  color: #ffffff;
  font-weight: bold;
}

.grid > .stat.wkrótce {
  padding: 2.5vh;
  justify-content: center;
  align-items: center;
  font-style: italic;
  color: #ffffff;
  text-align: center;
  font-size: 1.5vh;
}


</style>
