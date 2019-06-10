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
import VueLodash from 'vue-lodash'
import VeeValidate from 'vee-validate';

axios.defaults.baseURL = process.env.VUE_APP_API_ROOT;

Vue.config.productionTip = false

const options = { name: 'lodash' }
Vue.use(VueLodash, options)
Vue.use(VeeValidate, {
  inject: true,
  // Important to name this something other than 'fields'
  fieldsBagName: 'veeFields',
  errorBagName: 'veeErrors',
  events: ''
})

Vue.component('loader', Loader );

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
