<template>
  <div class="col-8 offset-2">
    <h1 class="text-center">Courses</h1>
    <loader v-if="loading"></loader>
    <div v-if="!loading">
      <div class="overflow-auto" v-if="courses.length > 0">
        <b-link class="btn btn-outline-primary btn-sm mb-2" :to="{ name: 'course', params: { id: 0}}">
          Add Course
        </b-link>
        <b-pagination v-model="currentPage" :total-rows="rows" :per-page="perPage" aria-controls="course-table" v-if="rows > perPage"></b-pagination>
        <b-table id="course-table" :items="courses" :fields="fields" :per-page="perPage" :current-page="currentPage" :striped="true" :hover="true">
          <template slot="actions" slot-scope="row">
            <b-link class="btn btn-outline-primary btn-sm" :to="{ name: 'course', params: { id: row.item.id }}">
              Edit
            </b-link>
          </template>
        </b-table>
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
