import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    authenticated: false,
    token: null,
    production: process.env.VUE_APP_PRODUCTION,
    apiRoot: process.env.VUE_APP_API_ROOT
  },
  mutations:{
    initialiseStore(state) {
      // Check if the ID exists
      if(localStorage.getItem('store')) {
        // Replace the state object with the stored item
        this.replaceState(
            Object.assign(state, JSON.parse(localStorage.getItem('store')))
        );
      }
    },
    setAuthenticated( state, status ){
      state.authenticated = status;
    },
    setToken( state, token ){
      state.token = token;
    },
    setProduction( state, production ){
      state.production = production;
    },
    setApiRoot( state, root ){
      state.apiRoot = root;
    }
  },

  actions:{
    login ( context ){
      context.commit('setAuthenticated', true );
      context.commit( 'setToken', 'moo')
    },
    logout ( context ){
      context.commit('setAuthenticated', false );
      context.commit('setToken', null );
    },
    setEnvironment( context, data ){
      context.commit('setProduction', data.production );
      context.commit('setApiRoot', data.apiRoot );
    }
  }

})

