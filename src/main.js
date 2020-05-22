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
import lodash from 'lodash'
import VeeValidate from 'vee-validate';
import Datetime from 'vue-datetime';

axios.defaults.baseURL = process.env.VUE_APP_API_ROOT;
axios.interceptors.response.use((response) => { // intercept the global error
  if( response.data.token != undefined && response.data.success != undefined && response.data.success ){
    store.dispatch( 'setToken', response.data.token )
  }
  return response
}, function (error) {
  if (error.response.status === 401) {
    store.dispatch( 'logout' );
    router.replace({ name: "login"});
    }
  // Do something with response error
  return Promise.reject(error)
})
Vue.config.productionTip = false

const options = { name: 'custom', lodash: lodash }
Vue.use(VueLodash, options)
Vue.use(VeeValidate, {
  inject: true,
  // Important to name this something other than 'fields'
  fieldsBagName: 'veeFields',
  errorBagName: 'veeErrors',
  events: ''
})

// You need a specific loader for CSS files
import 'vue-datetime/dist/vue-datetime.css'

Vue.use(Datetime)

Vue.use(require('vue-moment'));

Vue.component('loader', Loader );


new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
