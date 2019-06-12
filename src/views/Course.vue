<template>
    <div class="col-10 offset-1">
        <h1 class="text-center">{{ course.id == 0 ? 'Add' : 'Edit'}} Course</h1>
        <loader v-if="loading"></loader>
        <div v-if="!loading">
            <b-link class="btn btn-outline-success mb-4 btn-sm" :to="{ name: 'courses'}">
              <arrow-left-icon></arrow-left-icon>  Return to Course List
            </b-link>
            <b-alert :show="success" dismissible variant="success" fade>
                Course was saved!
            </b-alert>
            <b-alert :show="error" dismissible variant="danger" fade>
                <span class="bold">Oops...</span> there was a problem saving the course. Please try again.
            </b-alert>
            <b-form @submit="putCourse">
                <b-container>
                    <b-row>
                        <b-col>
                            <b-form-group label="Course Name" label-for="name">
                                <b-form-input name="name" data-vv-as="course name" id="name" v-model="course.name" type="text" v-validate="{required: true, max: 50}"></b-form-input>
                                <span class="text-danger">{{veeErrors.first('name')}}</span>
                            </b-form-group>
                        </b-col>

                    </b-row>
                    <b-row>
                        <b-col>
                            <b-form-group label="City" label-for="city">
                                <b-form-input name="city" id="city" v-model="course.city" type="text" v-validate="{required: true, max: 45}"></b-form-input>
                                <span class="text-danger">{{veeErrors.first('city')}}</span>
                            </b-form-group>
                        </b-col>
                        <b-col>
                            <b-form-group label="State" label-for="state">
                                <b-form-input name="state" id="state" v-model="course.state" type="text" v-validate="{required: true, max: 2}"></b-form-input>
                                <span class="text-danger">{{veeErrors.first('state')}}</span>
                            </b-form-group>
                        </b-col>
                    </b-row>
                    <b-row>
                        <b-col>
                            <b-form-group label="Slope" label-for="slope">
                                <b-form-input name="slope" id="slope" v-model="course.slope" type="text" v-validate="{required: true, numeric: true, max_value: 155, min_value: 55}"></b-form-input>
                                <span class="text-danger">{{veeErrors.first('slope')}}</span>
                            </b-form-group>
                        </b-col>
                        <b-col>
                            <b-form-group label="Rating" label-for="rating">
                                <b-form-input name="rating" id="rating" v-model="course.rating" type="text" v-validate="{required: true, decimal:1}"></b-form-input>
                                <span class="text-danger">{{veeErrors.first('rating')}}</span>
                            </b-form-group>
                        </b-col>
                    </b-row>
                    <b-row>
                        <b-col class="text-center bold">Front Nine</b-col>
                    </b-row>
                    <b-row v-if="frontErrors.length > 0">
                        <b-col>
                            <b-alert variant="danger" show>
                                <b>Oops....</b> seems there is an issue with the data for the front nine.
                                <ul>
                                    <li v-for="error in frontErrors">{{error}}</li>
                                </ul>
                            </b-alert>
                        </b-col>

                    </b-row>
                    <b-row>
                        <b-col class="text-right">
                            Hole
                        </b-col>
                        <b-col v-for="h in this.lodash.range(1, 10)" class="text-center">
                            <div class="text-center bold">{{ h }}</div>
                        </b-col>
                    </b-row>
                    <b-row class="mb-2">
                        <b-col class="text-right">
                            Par
                        </b-col>
                        <b-col v-for="p in this.lodash.range(1, 10)">
                            <b-form-input type="text" class="course-input mx-auto" :id="'p'+p" v-model="holes[p-1].par" maxlength="1" ></b-form-input>
                        </b-col>
                    </b-row>
                    <b-row>
                        <b-col class="text-right">
                            Handicap
                        </b-col>
                        <b-col v-for="p in this.lodash.range(1, 10)">
                            <b-form-input type="text" class="course-input mx-auto" :id="'h'+p" v-model="holes[p-1].handicap" maxlength="2" ></b-form-input>
                        </b-col>
                    </b-row>
                    <b-row>
                        <b-col class="text-center bold">Back Nine</b-col>
                    </b-row>
                    <b-row v-if="backErrors.length > 0">
                        <b-col>
                            <b-alert variant="danger" show>
                                <b>Oops....</b> seems there is an issue with the data for the back nine.
                                <ul>
                                    <li v-for="error in backErrors">{{error}}</li>
                                </ul>
                            </b-alert>
                        </b-col>

                    </b-row>
                    <b-row>
                        <b-col class="text-right">
                            Hole
                        </b-col>
                        <b-col v-for="h in lodash.range( 10, 19)">
                            <div class="text-center bold">{{ h }}</div>
                        </b-col>
                    </b-row>
                    <b-row class="mb-2">
                        <b-col class="text-right">
                            Par
                        </b-col>
                        <b-col v-for="p in lodash.range( 10, 19)" class="text-center">
                            <b-form-input type="text" class="course-input mx-auto" :id="'p'+p" v-model="holes[p-1].par" maxlength="1" ></b-form-input>
                        </b-col>
                    </b-row>
                    <b-row>
                        <b-col class="text-right">
                            Handicap
                        </b-col>
                        <b-col v-for="p in lodash.range( 10, 19)">
                            <b-form-input type="text" class="course-input mx-auto" :id="'h'+p" v-model="holes[p-1].handicap" maxlength="2" ></b-form-input>
                        </b-col>
                    </b-row>

                    <b-row class="mt-2">
                        <b-col>
                            <b-button type="submit" variant="primary"><content-save-icon></content-save-icon> Save Course</b-button>
                            <b-link class="btn btn-outline-secondary ml-2" :to="{ name: 'courses'}">
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
    import DiscIcon from "vue-material-design-icons/Disc";
    import ContentSaveIcon from "vue-material-design-icons/ContentSave";
    export default {
        components: {ContentSaveIcon, ArrowLeftIcon},
        data(){
            return {
                course: { id: 0 },
                loading: true,
                error: false,
                frontErrors: [],
                backErrors: [],
                success: false
            }
        },
        beforeCreate: function(){
            this.holes = [];
            for( let i = 0; i < 18; i++ ){
                this.holes.push( {id: null, par: null, handicap: null, number: i+1 })
            }
        },
        created: function(){
            this.fetchCourse();
        },
        watch:{
            '$route' : 'fetchCourse'
        },
        methods: {

            fetchCourse: function(){
                let self = this;
                self.loading = true;
                self.error = null
                axios.get('/api/course/id/' + self.$route.params.id,{
                    headers: {
                        'token': self.$store.state.token
                    },
                    })
                    .then( result => {
                        self.loading = false;
                        if( result.status == 200 && result.data.success ){
                            self.course = result.data.course;
                            if( result.data.holes.length > 0 ){
                                self.holes = result.data.holes;
                            }
                        }
                        else{
                            self.error = "There was a problem loading the course."
                        }
                    }, error => {
                        console.log( error );
                        self.error = "There was a problem loading the course."
                    })
            },
            putCourse: function( e ){
                e.preventDefault();
                this.success = false;
                this.error = false;
                this.$validator.validate().then(valid => {
                    let holesValid = this.validateHoles();
                    if (valid && holesValid ) {
                        let self = this;
                        axios({
                            method: 'POST',
                            url: '/api/putCourse',
                            data: {course: self.course, holes: self.holes },
                            headers: {
                                'token': self.$store.state.token
                            },
                            responseType: 'json'
                        })
                            .then( result => {
                                if( result.data.success ){
                                    console.log('success')
                                    self.course = result.data.course;

                                    self.success = true;
                                }
                                else{
                                    console.log('failed')
                                    this.error = true;
                                }
                            }, error => {
                                console.log( error );
                                this.error = true;
                            })
                    }
                });
            },
            validateHoles: function(){
                this.frontErrors = [];
                this.backErrors = [];
                // validate front nine errors
                for( let i=0; i<18; i++ ){
                    let hole = this.holes[ i ];
                    let errs = i < 9 ? this.frontErrors : this.backErrors;
                    if( isNaN( hole.par ) || hole.par < 3 || hole.par > 5 ){
                        errs.push('The par for hole ' + hole.number + ' must be an integer between 3 and 5')
                    }
                    if( isNaN( hole.handicap ) || hole.handicap < 1 || hole.handicap > 18 ){
                        errs.push('The handicap for hole ' + hole.number + ' must be an integer between 1 and 18')
                    }
                }
                return this.frontErrors.length == 0 && this.backErrors.length == 0;
            }
        }

    }
</script>