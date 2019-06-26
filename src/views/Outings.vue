<template>
  <div class="col-10 offset-1">
    <h1 class="text-center">Outings</h1>
    <loader v-if="loading"></loader>
    <div v-if="!loading">
      <div class="overflow-auto" v-if="outings.length > 0">
        <b-link class="btn btn-outline-primary btn-sm mb-2" :to="{ name: 'outing', params: { id: 0}}">
          <plus-icon></plus-icon> Add Outing
        </b-link>
        <b-pagination v-model="currentPage" :total-rows="rows" :per-page="perPage" aria-controls="outing-table" v-if="rows > perPage"></b-pagination>
        <div class="table-responsive">
        <b-table id="course-table" :items="outings" :fields="fields" :per-page="perPage" :current-page="currentPage" :striped="true" :hover="true">
          <template slot="actions" slot-scope="row">
            <b-link class="btn btn-outline-primary btn-sm" :to="{ name: 'outing', params: { id: row.item.id }}" title="Edit Outing">
              <pencil-icon></pencil-icon>
            </b-link>
            <b-link class="btn btn-outline-success btn-sm ml-2" :to="{ name: 'scoring', params: { id: row.item.id }}" title="Score Outing">
              <golf-icon></golf-icon>
            </b-link>
          </template>
          <template slot="organizer" slot-scope="row">
            <b-link :href="'mailto:' + row.item.manager.email">{{row.item.manager.name}}</b-link>
          </template>
          <template slot="course" slot-scope="row">
            <div>{{row.item.course.name}}</div>
            <div class="small">{{row.item.course.location}}</div>
          </template>
          <template slot="date" slot-scope="row">
            {{ row.item.date | moment('dddd MMMM D, YYYY')}} {{ row.item.teeTime | moment('h:mm a')}}
          </template>
        </b-table>
        </div>
      </div>
      <div v-if="outings.length == 0">
        <div class="alert alert-info">
          <p>There are currently no outings in the system. <b-link :to="{ name: 'outing', params: { id: 0 }}">Click here</b-link> to add an outing.</p>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
  import axios from 'axios'
  import PlusIcon from "vue-material-design-icons/Plus";
  import PencilIcon from "vue-material-design-icons/Pencil";
  import GolfIcon from "vue-material-design-icons/Golf";
  export default {
    components: {GolfIcon, PencilIcon, PlusIcon},
    data(){
      return {
        outings: [],
        loading: true,
        error: '',
        perPage: 10,
        currentPage: 1,
        fields: {
          id: {
            key: 'actions',
            label: 'Actions'
          },
          date:{
            label: 'Date/Time',
            sortable: true
          },
          course:{
            key: 'course',
            label: 'Course'
          },
          manager:{
            key: 'organizer',
            label: 'Organizer'
          }
        }
      }
    },
    created: function(){
      this.fetchOutings()
    },
    watch: {
      '$route': 'fetchOutings'
    },
    methods:{
      fetchOutings(){
        let self = this;
        self.loading = true;
        axios.get('/api/outings',{
          headers: {
            token: self.$store.state.token
          },
        })
                .then( result => {
                  self.loading = false;
                  if( result.status == 200 && result.data.success ){
                    self.outings = result.data.outings;
                  }
                  else{
                    self.error = "There was a problem loading the outing list"
                  }
                }, error => {
                  self.loading = false;
                  self.error = "There was a problem loading the outing list"
                })
      }
    },
    computed :{
      rows(){
        return this.outings.length;
      }
    }

  }
</script>