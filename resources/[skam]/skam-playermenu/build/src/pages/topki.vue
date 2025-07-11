<template>
  <div>
    <div class="ranking-container">
      <div class="ranking-column" v-for="(category, idx) in categories" :key="idx">
        <div class="ranking-title">{{ category.title }}</div>
        <div class="ranking-list">
          <div
            class="ranking-item"
            v-for="(item, n) in getCategoryList(category.key)"
            :key="n"
          >
              <span class="ranking-org">{{ item.name.length > 10 ? item.name.slice(0, 10) + '…' : item.name }}</span>
            <span class="ranking-score">
              {{ category.key === 'czas' ? item.scoreFormatted : item.score }}
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    rankingData: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      categories: [
        { title: 'BITKI', key: 'bitki' },
        { title: 'RANKING', key: 'ranking' },
        { title: 'CZAS NA SERWERZE', key: 'czas' },
        { title: 'DUELE', key: 'duele' }
      ]
    }
  },
  methods: {
    getCategoryList(key) {
      return this.rankingData[key] || []
    }
  }
}
</script>

<style scoped>
.ranking-container {
  display: flex;
  justify-content: center;
  gap: 2vh;
  padding: 2vh 0;
  background: transparent;
}
.ranking-column {
  background: rgba(5, 5, 5, 0.75);
  border: rgba(32, 32, 32, 1) solid 0.1vh;
  border-radius: 1.2vh;
  padding: 1.2vh 1.2vh 0.8vh 1.2vh;
  width: 20vh;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.ranking-title {
  color: #fff;
  font-size: 1.4vh;
  font-weight: 700;
  letter-spacing: 0.5px;
  margin-bottom: 1.2vh;
  text-align: center;
}
.ranking-list {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 0.4vh;
}
.ranking-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: rgba(20,20,20,0.8);
  border-radius: 0.7vh;
  padding: 0.4vh 0.8vh;
  color: #fff;
  font-size: 1.1vh;
  font-weight: 500;
  border: 1px solid #222;
}
.ranking-org {
  color: #fff;
  font-weight: 500;
}
.ranking-score {
  background: #232323;
  border-radius: 0.7vh;
  padding: 0.2vh 1vh;
  font-weight: 700;
  color: #fff;
  font-size: 1vh;
}

</style>