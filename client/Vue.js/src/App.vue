<template>
  <div id="app">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <router-link to="/" class="navbar-brand">Golf Outing</router-link>
      <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto" v-show="$store.state.authenticated">
          <li class="nav-item" v-bind:class="{ 'active' : $route.path == '/'}">
            <router-link class="nav-link" to="/">Home <span class="sr-only">(current)</span></router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link" to="/outings" v-bind:class="{ 'active' : isOutingNav}">Outings</router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link" to="/courses" v-bind:class="{ 'active' : isCourseNav}">Courses</router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link" to="/golfers" v-bind:class="{ 'active' : isGolferNav}">Golfers</router-link>
          </li>
          <li class="nav-item">
            <a href="#" @click="logout()" class="nav-link">Logout</a>
          </li>
        </ul>
        <div class="alert alert-danger bold" id="dev-mode" v-if="!$store.state.production">DEVELOPMENT MODE</div>
      </div>
    </nav>
    <router-view @authenticated="setAuthenticated"/>
  </div>
</template>

<script>

  export default {
    name: 'App',
    data() {
      return {
        authenticated: false,
        mockAccount: {
          username: "scott.stroz@gmail.com",
          password: "password"
        }
      }
    },
    mounted() {
      this.$store.dispatch( 'setEnvironment', { production: process.env.VUE_APP_PRODUCTION == 'false' ? false : true, apiRoot: process.env.VUE_APP_API_ROOT})
      if(!this.$store.state.authenticated) {
        this.$router.replace({ name: "login" });
      }
    },
    methods: {
      setAuthenticated(data) {
        if( data.success ){
          this.$store.dispatch( 'login' );
          this.$store.dispatch( 'setToken', data.token )
        }

      },
      logout() {
        this.$store.dispatch( 'logout' );
        this.$router.replace({ name: "login" })
      }
    },
    beforeCreate() {
      this.$store.subscribe((mutation, state) => {
        // Store the state object as a JSON string
        localStorage.setItem('store', JSON.stringify(state));
      });
      this.$store.commit('initialiseStore');
    },

    computed:{
      isCourseNav(){
        return this.$route.name == 'courses' || this.$route.name == 'course';
      },
      isOutingNav(){
        return this.$route.name == 'outings' || this.$route.name == 'outing' || this.$route.name == 'scoring';
      },
      isGolferNav(){
        return this.$route.name == 'golfers';
      }
    }
  }

</script>
<style lang="scss">
  @import './assets/styles/custom.scss';
</style>

