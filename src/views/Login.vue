<template>
  <div class="row justify-content-md-center">
    <div class="col-md-4 col-sm-12">
      <h1>Login</h1>
      <b-alert dissmissable variant="danger" v-model="loginFailed">Login unsuccessful.</b-alert>
      <b-form>
        <b-form-group id="user-group" label="Email address:" label-for="username" >
          <b-form-input id="username" v-model="input.username" type="email" required placeholder="Email Address" ></b-form-input>
        </b-form-group>
        <b-form-group id="password-group" label="Password:" label-for="password" >
          <b-form-input id="password" v-model="input.password" type="password" required placeholder="Password" ></b-form-input>
        </b-form-group>
        <b-button type="button" variant="primary" @click="login()">Login</b-button>
      </b-form>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';
  export default {
    name: 'Login',
    data() {
      return {
        input: {
          username: "",
          password: ""
        },
        loginFailed : false
      }
    },
    methods: {
      login() {
        this.loginFailed = false;
        let self = this;
        axios({
            method: 'POST',
            url: '/api/login',
            data: self.input,
          headers: {
            token: self.$store.state.token
          },
            responseType: 'json'
        })
        .then( result => {
          if( result.data.success ){
            this.$emit("authenticated", result.data );
            this.$router.replace({ name: "home" });
          }
          else{
            this.loginFailed = true;
          }
        }, error => {
          console.log( error );
          this.loginFailed = true;
        })
      }
    }
  }
</script>