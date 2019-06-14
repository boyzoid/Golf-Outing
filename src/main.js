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
import Datetime from 'vue-datetime';

axios.defaults.baseURL = process.env.VUE_APP_API_ROOT;
axios.defaults.headers.common['token'] = JSON.parse( localStorage.getItem('store') ).token;
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
Vue.use(require('vue-moment'));

// You need a specific loader for CSS files
import 'vue-datetime/dist/vue-datetime.css'

Vue.use(Datetime)

Vue.component('loader', Loader );


new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
