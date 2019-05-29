import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    loggedIn: false
  },
  mutations:{
    initialiseStore(state) {
      // Check if the ID exists
      console.log('mooooooooooooooooooooooooooooooooooo')
      console.log( localStorage.getItem('store') );
      if(localStorage.getItem('store')) {
        // Replace the state object with the stored item
        this.replaceState(
            Object.assign(state, JSON.parse(localStorage.getItem('store')))
        );
      }
    }
  }
})

