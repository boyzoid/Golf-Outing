import '@babel/polyfill'
import 'mutationobserver-shim'
import Vue from 'vue'
import './plugins/bootstrap-vue'
import App from './App.vue'
import router from './router'
import store from './store'
import 'bootstrap';
import axios from 'axios';
import Loader from './components/Loader.vue';

axios.defaults.baseURL = process.env.VUE_APP_API_ROOT;

Vue.config.productionTip = false

Vue.component('loader', Loader );


new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
