import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    authenticated: false,
    token: null
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
    }
  }

})

