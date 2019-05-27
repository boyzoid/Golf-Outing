import Vue from 'vue'
import Router from 'vue-router'
import Home from './views/Home.vue'


Vue.use(Router)

export default new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/login',
      name: 'login',
      component: () => import(/* webpackChunkName: "courses" */ './views/Login.vue')
    },
    {
      path: '/outings',
      name: 'outings',
      component: () => import(/* webpackChunkName: "outings" */ './views/Outings.vue')
    },
    {
      path: '/courses',
      name: 'courses',
      component: () => import(/* webpackChunkName: "courses" */ './views/Courses.vue')
    }
  ]
})
