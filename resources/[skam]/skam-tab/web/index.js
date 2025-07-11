const panels = [
  {
    icon: "fa-regular fa-wand-magic-sparkles",
    title: "/SKLEP",
    desc: "Zakupisz tutaj przedmioty",
  },
  {
    icon: "fa-regular fa-treasure-chest",
    title: "/SKRZYNKI",
    desc: "Otwiera menu skrzynek",
  },
  {
    icon: "fa-regular fa-kit-medical",
    title: "/KIT",
    desc: "Odbierasz przedmioty startowe",
  },
  {
    icon: "fa-regular fa-flag",
    title: "/TPMENU",
    desc: "Teleportuj się na dowolny gz",
  },
  {
    icon: "fa-regular fa-user",
    title: "/SKIN",
    desc: "Zmień swojego skina",
  },
  {
    icon: "fa-regular fa-gear",
    title: "/HUD",
    desc: "Dowolnie zmodyfikuj swój hud",
  },
];

document.addEventListener('DOMContentLoaded', () => {
    const panelsContainer = document.getElementById("panels-container");
    panels.forEach((panel, idx) => {
      const div = document.createElement("div");
      div.className = "panel";
      div.style.setProperty("--panel-index", idx + 1);
      div.innerHTML = `
        <i class="${panel.icon}" aria-hidden="true"></i>
        <div class="title">${panel.title}</div>
        <div class="desc">${panel.desc}</div>
      `;
      panelsContainer.appendChild(div);
    });

    let menuVisible = false;
    let inGreenZone = false;
    let animationInProgress = false;
    let tabPressAllowed = true;
    const openText = "Kliknij <span class='tab'>TAB</span> aby otworzyć menu pomocy";
    const closeText = "Zamknij menu za pomocą <span class='tab'>TAB</span>";
    const ANIMATION_DURATION = 200;

    const tabBox = document.querySelector('.tab-box');
    const tabOpen = document.querySelector('.tab-open');
    const tabOpenText = document.getElementById('tab-open-text');

    function updateTabOpenText() {
        tabOpenText.innerHTML = menuVisible ? closeText : openText;
    }

    function showMenu() {
        if (animationInProgress) return;
        animationInProgress = true;
        menuVisible = true;
        updateTabOpenText();
        tabBox.style.display = 'flex';
        tabBox.classList.remove('hide-animation');
        tabBox.classList.add('show-animation');
        setTimeout(() => animationInProgress = false, ANIMATION_DURATION);
    }

    function hideMenu() {
        if (animationInProgress) return;
        animationInProgress = true;
        menuVisible = false;
        updateTabOpenText();
        tabBox.classList.remove('show-animation');
        tabBox.classList.add('hide-animation');
        setTimeout(() => {
            tabBox.style.display = 'none';
            animationInProgress = false;
        }, ANIMATION_DURATION);
    }

    function updateTabOpenVisibility() {
        tabOpen.style.display = inGreenZone ? 'flex' : 'none';
    }

    window.addEventListener('message', (event) => {
        const { type, inGreenZone: zone, show } = event.data;
        if (type === 'showTab') {
            inGreenZone = zone;
            show ? showMenu() : hideMenu();
        } else if (type === 'showTabOpen') {
            inGreenZone = zone;
            updateTabOpenVisibility();
            updateTabOpenText();
        }
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Tab' && tabPressAllowed) {
            e.preventDefault();
            tabPressAllowed = false;
            fetch('https://skam-tab/tabPressed', { method: 'POST', body: '{}' });
            setTimeout(() => tabPressAllowed = true, ANIMATION_DURATION);
        }
    });
});