<template>
    <div class="col-8 offset-2">
        <h1 class="text-center">{{ outing.id == 0 ? 'Add' : 'Edit'}} Outing </h1>
        <loader v-if="loading"></loader>
        <div v-if="!loading">
            <b-link class="btn btn-outline-success mb-4 btn-sm" :to="{ name: 'outings'}">
               <arrow-left-icon></arrow-left-icon> Return to Outing List
            </b-link>
            <b-alert :show="success" dismissible variant="success" fade>
                Outing was saved!
            </b-alert>
            <b-alert :show="error" dismissible variant="danger" fade>
                <span class="bold">Oops...</span> there was a problem saving the outing. Please try again.
            </b-alert>
            <b-alert :show="loadError" dismissible variant="danger" fade>
                <span class="bold">Oops...</span> {{ loadError }}.
            </b-alert>
            <b-form @submit="putOuting">
                <b-container>
                    <b-row>
                        <b-col>
                            <b-form-group label="Course" label-for="course">
                                <b-form-select v-model="outing.courseId" id="course" name="course" placeholder="Choose course" v-validate="{required: true}">
                                    <option value="">Please select a course</option>
                                    <option v-for="course in courses" :value="course.id">{{course.name}}</option>
                                </b-form-select>
                                <span class="text-danger">{{veeErrors.first('course')}}</span>
                            </b-form-group>
                        </b-col>
                        <b-col>
                            <b-form-group label="Organizer" label-for="organizer">
                                <b-form-select v-model="outing.organizer" v-validate="{required: true}" name="organizer">
                                    <option value="">Please select an organizer</option>
                                    <option v-for="golfer in golfers" :value="golfer.id">{{golfer.fullname}}</option>
                                </b-form-select>
                                <span class="text-danger">{{veeErrors.first('organizer')}}</span>
                            </b-form-group>
                        </b-col>
                    </b-row>
                    <b-row>
                        <b-col>
                            <b-form-group label="Date" label-for="date">
                                <datetime v-model="outing.date" input-id="date" format="cccc LLLL dd, yyyy" input-class="form-control"  value-zone="local" name="date" v-validate="{required: true}" :week-start="7" title="Outing Date"></datetime>
                                <span class="text-danger">{{veeErrors.first('date')}}</span>
                            </b-form-group>
                        </b-col>
                        <b-col>
                            <b-form-group label="Tee time" label-for="teeTime" description="If multiple tee times are used, put the earliest one here.">
                                <datetime type="time" use12-hour v-model="outing.teeTime" input-id="teeTime" format="t" input-class="form-control"  value-zone="local" data-vv-as="tee time" name="teeTime" v-validate="{required: true}" title="Tee Time"></datetime>
                                <span class="text-danger">{{veeErrors.first('teeTime')}}</span>
                            </b-form-group>
                        </b-col>
                    </b-row>
                    <b-row>
                        <b-col class="text-center mb-2">
                            <span class="bold">Golfers Playing</span>
                            <b-link class="ml-2" title="Add Golfer"><plus-circle-icon title="Add Golfer"></plus-circle-icon></b-link>
                        </b-col>
                    </b-row>
                    <b-row>
                        <b-col class="col-md-8 offset-md-2">
                            <table class="table table-striped table-hover table-sm">
                                <thead class="thead-dark">
                                    <tr>
                                        <th></th>
                                        <th>Golfer</th>
                                        <th>Handicap</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="golfer in outingGolfers">
                                        <td></td>
                                        <td>{{golfer.name}}</td>
                                        <td>{{golfer.index}}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </b-col>
                    </b-row>
                    <b-row class="mt-2">
                        <b-col>
                            <b-button type="submit" variant="primary"><content-save-icon></content-save-icon> Save Outing</b-button>
                            <b-link class="btn btn-outline-secondary ml-2" :to="{ name: 'outings'}">
                                Cancel
                            </b-link>
                        </b-col>

                    </b-row>
                </b-container>

            </b-form>
        </div>
    </div>
</template>
<script>
    import axios from 'axios'
    import ArrowLeftIcon from "vue-material-design-icons/ArrowLeft";
    import ContentSaveIcon from "vue-material-design-icons/ContentSave";
    import PlusCircleIcon from "vue-material-design-icons/PlusCircle";
    export default {
        components: {PlusCircleIcon, ContentSaveIcon, ArrowLeftIcon},
        data() {
            return {
                outing: {id: 0},
                loading: true,
                error: false,
                success: false,
                loadError: null,
                courses: [],
                golfers: [],
                outingGolfers: []
            }
        },
        created: function(){
            this.fetchOuting();

        },
        watch:{
            '$route' : 'fetchOuting'
        },
        methods:{
            fetchOuting: function(){
                if( this.courses.length == 0 ){
                    this.fetchCourses();
                }
                if( this.golfers.length == 0 ){
                    this.fetchGolfers();
                }

                let self = this;
                self.loading = true;
                self.error = null
                axios.get('/api/outing/id/' + self.$route.params.id,{
                    headers: {
                        'token': self.$store.state.token
                    },
                })
                    .then( result => {
                        self.loading = false;
                        if( result.status == 200 && result.data.success ){
                            self.outing = result.data.outing;
                            self.outingGolfers = result.data.outingGolfers;
                        }
                        else{
                            self.loadError = "There was a problem loading the outing."
                        }
                    }, error => {
                        console.log( error );
                        self.loadError = "There was a problem loading the outing."
                    })
            },
            fetchCourses(){
                let self = this;
                self.loading = true;
                axios.get('/api/courses')
                    .then( result => {
                        self.loading = false;
                        if( result.status == 200 && result.data.success ){
                            self.courses = result.data.courses;
                        }
                    }, error => {
                        console.log( error );
                    })
            },
            fetchGolfers(){
                let self = this;
                self.loading = true;
                axios.get('/api/golfers')
                    .then( result => {
                        self.loading = false;
                        if( result.status == 200 && result.data.success ){
                            self.golfers = result.data.golfers;
                        }
                    }, error => {
                        console.log( error );
                    })
            },
            putOuting(e){
                e.preventDefault();
                this.success = false;
                this.error = false;

                this.$validator.validate().then(valid => {
                    if (valid ) {
                        let self = this;
                        axios({
                            method: 'POST',
                            url: '/api/putOuting',
                            data: {outing: this.outing },
                            headers: {
                                'token': self.$store.state.token
                            },
                            responseType: 'json'
                        })
                            .then( result => {
                                if( result.data.success ){
                                    self.outing = result.data.outing;

                                    self.success = true;
                                }
                                else{
                                    this.error = true;
                                }
                            }, error => {
                                console.log( error );
                                this.error = true;
                            })
                    }
                });
            }
        }
    }
</script>