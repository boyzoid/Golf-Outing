<template>
  <div class="col-8 offset-2">
    <h1 class="text-center">Courses</h1>
    <loader v-if="loading"></loader>
    <div v-if="!loading">
      <div class="overflow-auto">
        <b-pagination v-model="currentPage" :total-rows="rows" :per-page="perPage" aria-controls="course-table" v-if="rows > perPage"></b-pagination>
        <b-table id="course-table" :items="courses" :fields="fields" :per-page="perPage" :current-page="currentPage" :striped="true" :hover="true">
          <template slot="actions" slot-scope="row">
            <b-button size="sm" variant="outline-primary">
              Edit
            </b-button>
          </template>
        </b-table>
      </div>
    </div>
  </div>
</template>

<script>
  import axios from 'axios'


  export default {
    data(){
      return {
        courses: [],
        loading: true,
        error: '',
        perPage: 10,
        currentPage: 1,
        fields: {
          id:{
            key: 'actions',
            label: 'Actions'
          },
          name: {
            label: 'Course Name',
            sortable: true
          },
          city:{
            label: 'City'
          },
          state:{
            label: 'State'
          },
          slope:{
            label: 'Slope'
          },
          rating: {
            label: 'Rating'
          }
        },
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
        axios.get('/api/courses')
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
