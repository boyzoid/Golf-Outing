<template>
  <div class="col-10 offset-1">
    <h1 class="text-center">Courses</h1>
    <loader v-if="loading"></loader>
    <div v-if="!loading">
      <div class="overflow-auto" v-if="courses.length > 0">
        <b-link class="btn btn-outline-primary btn-sm mb-2" :to="{ name: 'course', params: { id: 0}}">
          <plus-icon></plus-icon> Add Course
        </b-link>
        <b-pagination v-model="currentPage" :total-rows="rows" :per-page="perPage" aria-controls="course-table" v-if="rows > perPage"></b-pagination>
        <div class="table-responsive">
        <b-table id="course-table" :items="courses" :fields="fields" :per-page="perPage" :current-page="currentPage" :striped="true" :hover="true">
          <template v-slot:cell(actions)="data">
            <b-link class="btn btn-outline-primary btn-sm" :to="{ name: 'course', params: { id: data.item.id }}" :title="'Edit ' + data.item.name">
              <pencil-icon></pencil-icon>
            </b-link>
          </template>
        </b-table>
        </div>
      </div>
      <div v-if="courses.length == 0">
        <div class="alert alert-info">
          <p>There are currently no courses in the system. <b-link :to="{ name: 'course', params: { id: 0 }}">Click here</b-link> to add a course.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import axios from 'axios'
  import PlusIcon from "vue-material-design-icons/Plus";
  import PencilIcon from "vue-material-design-icons/Pencil";
  export default {
    components: {PencilIcon, PlusIcon},
    data(){
      return {
        courses: [],
        loading: true,
        error: '',
        perPage: 10,
        currentPage: 1,
        fields: [

          {
            key: 'actions',
            label: 'Actions'
          },

          {
            key: 'name',
            label: 'Course Name',
            sortable: true
          },

          {
            key: 'city',
            label: 'City'
          },

          {
            key: 'state',
            label: 'State'
          },

          {
            key: 'slope',
            label: 'Slope'
          },

          {
            key: 'rating',
            label: 'Rating'
          }
        ],
      }
    },
    created: function(){
      this.fetchCourses()
    },
    watch: {
      '$route': 'fetchCourses'
    },
    methods:{
      fetchCourses(){
        let self = this;
        self.loading = true;
        axios.get('/course/list',{
          headers: {
            token: self.$store.state.token
          },
        })
                .then( result => {
                  self.loading = false;
                  if( result.status == 200 && result.data.success ){
                    self.courses = result.data.courses;
                  }
                  else{
                    self.error = "There was a problem loading the course list"
                  }
                }, error => {
                  console.log( error );
                  self.error = "There was a problem loading the course list"
                })
      }
    },
    computed :{
      rows(){
        return this.courses.length;
      }
    }

  }
</script>
