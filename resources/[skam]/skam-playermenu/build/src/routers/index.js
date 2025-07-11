import { createRouter, createWebHashHistory } from 'vue-router';

import Home from '../pages/home.vue';
import Strefy from '../pages/strefy.vue';
import Bank from '../pages/bank.vue';
import Topki from '../pages/topki.vue';

const routes = [
  { path: '/', component: Home, props: true },
  { path: '/strefy', component: Strefy, props: true },
  { path: '/bank', component: Bank, props: true },
  { path: '/topki', component: Topki, props: true }
];

const router = createRouter({
  history: createWebHashHistory(),
  routes
});
export default router;
