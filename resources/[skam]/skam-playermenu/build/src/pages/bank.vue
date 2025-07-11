<template>
    <div class="bank" v-if="playerData">
        <div class="bank__top">
            <div class="bank__info">
                <span class="bank__label">Stan konta:</span>
                <span class="bank__value">
                    <vue-count-up 
                        :start-val="0"
                        :end-val="Number(playerData.account)"
                        :duration="1"
                        :decimals="0"
                        :separator="','"
                        prefix="$"
                    />
                </span>
            </div>
            <div class="bank__divider"></div>
            <div class="bank__info">
                <span class="bank__label">Posiadana gotówka:</span>
                <span class="bank__value">
                    <vue-count-up 
                        :start-val="0"
                        :end-val="Number(playerData.cash)"
                        :duration="1"
                        :decimals="0"
                        :separator="','"
                        prefix="$"
                    />
                </span>
            </div>
        </div>
        <div class="bank__bottom">
            <form class="bank__form" @submit.prevent="BankMode">
                <div class="bank__input-group">
                    <input
                        class="bank__input"
                        type="text"
                        v-model="amount"
                        :placeholder="placeholder"
                    />
                    <input
                        v-if="mode === 'transfer'"
                        class="bank__input bank__input--small"
                        type="text"
                        v-model="target"
                        placeholder="ID odbiorcy"
                    />
                </div>
                <button class="bank__confirm" type="submit">Zatwierdź</button>
            </form>
            <div class="bank__actions">
                <button
                    class="bank__action"
                    :class="{ 'bank__action--active': mode === 'deposit' }"
                    @click="mode = 'deposit'"
                >Wpłata</button>
                <button
                    class="bank__action"
                    :class="{ 'bank__action--active': mode === 'withdraw' }"
                    @click="mode = 'withdraw'"
                >Wypłata</button>
                <button
                    class="bank__action"
                    :class="{ 'bank__action--active': mode === 'transfer' }"
                    @click="mode = 'transfer'"
                >Przelew</button>
            </div>
        </div>
    </div>
</template>

<script>
import VueCountUp from 'vue-countup-v3';

export default {
  components: {
    VueCountUp
  },
  props: {
    playerData: Object,
    refreshData: Function
  },
  data() {
    return {
      mode: 'deposit',
      amount: '',
      target: ''
    }
  },
  computed: {
    placeholder() {
      if (this.mode === 'deposit') return 'Wprowadź kwotę...'
      if (this.mode === 'withdraw') return 'Wprowadź kwotę...'
      if (this.mode === 'transfer') return 'Kwota przelewu...'
      return ''
    }
  },
  methods: {
    BankMode() {
      if (!this.amount || this.amount.trim() === '') {
        return;
      }

      if (this.mode === 'transfer' && (!this.target || this.target.trim() === '')) {
        return;
      }

      let endpoint = ''
      if (this.mode === 'deposit') endpoint = 'deposit'
      if (this.mode === 'withdraw') endpoint = 'withdraw'
      if (this.mode === 'transfer') endpoint = 'transfer'

      fetch(`https://skam-playermenu/${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          amount: this.amount,
          target: this.target
        })
      })
      .then(() => {
        this.amount = ''
        this.target = ''
        this.refreshData()
      })
      .catch(() => {});
    }
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
.money-animate {
    animation: moneymoney 0.7s;
}
@keyframes moneymoney {
    0% { color: var(--color-light); transform: scale(1.2);}
    100% { color: var(--color-white); transform: scale(1);}
}
.bank__top {
    border: solid var(--color-border) 0.1vh;
    margin-top: 4vh;
    width: 90%;
    background: var(--color-black);
    border-radius: 2vh;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 2.5vh 4.8vh;
}
.bank__info {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}
.bank__label {
    color: var(--color-gray);
    font-size: 1.5vh; 
    font-weight: bold;
    margin-bottom: 0.4vh;
}
.bank__value {
    color: var(--color-white);;
    font-size: 2.8vh; 
    font-weight: bold;
    letter-spacing: 0.1vh;
}
.bank__divider {
    width: 0.2vh;
    height: 6vh; 
    background: var(--color-border);
    margin: 0 3vh;
    border-radius: 0.2vh;
}
.bank__bottom {
    margin-top: 3vh;
    width: 90%;
    height: 28vh; 
    background: var(--color-black);;
    border: var(--color-border) solid 0.1vh;
    border-radius: 3vh;
    padding: 2vh 3.5vh; 
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}
.bank__form {
    display: flex;
    align-items: center;
    width: 100%;
    margin-bottom: 1.2vh; 
    gap: 1.2vh; 
}
.bank__input-group {
    display: flex;
    width: 100%;
    gap: 0.8vh; 
}
.bank__input {
    width: 100%;
    padding: 1vh 1.2vh; 
    font-size: 1.6vh; 
    border-radius: 1vh; 
    border: none;
    background: var(--color-gray);
    color: var(--color-white);
    margin-bottom: 0;
    transition: width 0.2s;
    outline: none;
    font-weight: 500;
}
.bank__input--small {
    width: 8vh; 
    min-width: 6vh; 
    font-size: 1.1vh; 
    padding: 1vh 0.8vh; 
}
.bank__confirm {
    padding: 1vh 2vh; 
    font-size: 1.4vh; 
    border-radius: 1vh; 
    border: none;
    background: var(--color-gray);
    color: var(--color-white);
    font-weight: 550;
    margin-left: 0;
    transition: background 0.2s;
    cursor: pointer;
    white-space: nowrap;
}
.bank__confirm:hover {
    background: #444;
}
.bank__actions {
    display: flex;
    gap: 0.8vh; 
    margin-bottom: 0;
}
.bank__action {
    padding: 0.5vh 1.2vh; 
    font-size: 1.1vh; 
    border-radius: 0.7vh; 
    border: 0.15vh solid var(--color-white);
    background: transparent;
    color: var(--color-white);
    font-weight: bold;
    opacity: 0.5;
    cursor: pointer;
    transition: all 0.2s;
}
.bank__action--active {
    background: var(--color-gray);
    color: var(--color-white);
    opacity: 1;
    cursor: pointer;
    border: 0.15vh solid var(--color-white);
}
</style>
