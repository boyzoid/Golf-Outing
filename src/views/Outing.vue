<template>
    <div class="col-10 offset-1">
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
                        <b-col cols="12" md="6">
                            <b-form-group label="Course" label-for="course">
                                <b-form-select v-model="outing.course.id" id="course" name="course" placeholder="Choose course" v-validate="{required: true}">
                                    <option value="">Please select a course</option>
                                    <option v-for="course in courses" :value="course.id">{{course.name}}</option>
                                </b-form-select>
                                <span class="text-danger">{{veeErrors.first('course')}}</span>
                            </b-form-group>
                        </b-col>
                        <b-col cols="12" md="6">
                            <b-form-group label="Organizer" label-for="organizer">
                                <b-form-select v-model="outing.organizer.id" v-validate="{required: true}" name="organizer">
                                    <option value="">Please select an organizer</option>
                                    <option v-for="golfer in allGolfers" :value="golfer.id">{{golfer.lastName}}, {{golfer.firstName}}</option>
                                </b-form-select>
                                <span class="text-danger">{{veeErrors.first('organizer')}}</span>
                            </b-form-group>
                        </b-col>
                    </b-row>
                    <b-row>
                        <b-col cols="12" md="6">
                            <b-form-group label="Date" label-for="date">
                                <datetime v-model="outing.date" input-id="date" format="MM/dd/yyyy" input-class="form-control"  value-zone="local" name="date" v-validate="{required: true}" :week-start="7" title="Outing Date"></datetime>
                                <span class="text-danger">{{veeErrors.first('date')}}</span>
                            </b-form-group>
                        </b-col>
                        <b-col cols="12" md="6">
                            <b-form-group label="Tee time" label-for="teeTime" description="If multiple tee times are used, put the earliest one here.">
                                <datetime type="time" use12-hour v-model="outing.teeTime" input-id="teeTime" format="t" input-class="form-control"  value-zone="local" data-vv-as="tee time" name="teeTime" v-validate="{required: true}" title="Tee Time"></datetime>
                                <span class="text-danger">{{veeErrors.first('teeTime')}}</span>
                            </b-form-group>
                        </b-col>
                    </b-row>
                    <b-row class="mt-2">
                        <b-col cols="12" md="6">
                            <b-button type="submit" variant="primary"><content-save-icon></content-save-icon> Save Outing</b-button>
                            <b-link class="btn btn-outline-secondary ml-2" :to="{ name: 'outings'}">
                                Cancel
                            </b-link>
                        </b-col>
                    </b-row>
                    <b-row  v-if="outing.id">
                        <b-col class="text-center mb-2">
                            <span class="bold">Golfers</span>
                            <b-link class="ml-2" title="Add Golfer" @click="openAddGolfers()"><plus-circle-icon title="Add Golfers To Outing"></plus-circle-icon></b-link>
                        </b-col>
                    </b-row>
                    <b-row v-if="outing.id">
                        <b-col class="col-md-8 offset-md-2">
                            <b-alert :show="outing.outingGolfers.length == 0" variant="info">
                                There are currently no golfers assigned to this outing. <b-link href="#" @click="openAddGolfers()">click here</b-link> to add golfers.
                            </b-alert>
                            <table class="table table-striped table-hover table-sm" v-if="outing.outingGolfers.length > 0">
                                <thead class="thead-dark">
                                    <tr>
                                        <th></th>
                                        <th>Golfer</th>
                                        <th>Handicap</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="golfer in outing.outingGolfers">
                                        <td class="action-2">
                                            <a class="text-danger pr-2" href="#" @click="removeGolfer( golfer.id)" :title="'Remove ' + golfer.golfer.firstName + ' from outing'"><trash-can-icon :size="20" :title="'Remove ' + golfer.golfer.firstName + ' from outing'"></trash-can-icon></a>
                                            <a class="text-primary " href="#" @click="openEdit(golfer)" :title="'Update handicap for ' + golfer.golfer.firstName"><pencil-icon :size="20" :title="'Update handicap for ' + golfer.golfer.firstName"></pencil-icon></a>
                                        </td>
                                        <td >{{golfer.golfer.lastName}}, {{golfer.golfer.firstName}}</td>
                                        <td>{{golfer.handicapIndex}}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </b-col>
                    </b-row>
                </b-container>
                <b-modal id="add-to-outing" title="Add Golfer to Outing" v-model="addToOuting" @ok="putGolfers" v-if="outing.id">
                <b-form>
                    <b-alert variant="info" :show="golfers.length == 0">
                        <p>There are no available golfers to add.</p>
                        <p>Click here to add a new golfer.</p>
                    </b-alert>
                    <b-form-group label="Golfers" label-for="Golfers" v-if="golfers.length > 0">
                        <b-form-select v-model="addGolfers"  id="golfers" name="golfers" placeholder="Choose golfers" multiple>
                            <option v-for="golfer in golfers" :value="golfer.id">{{golfer.lastName}}, {{golfer.firstName}}</option>
                        </b-form-select>
                    </b-form-group>
                </b-form>
                    <template slot="modal-footer" slot-scope="{ ok, close }">
                        <b-button variant="secondary" @click="close()">
                            Cancel
                        </b-button>
                        <b-button variant="primary" @click="ok()" v-if="golfers.length > 0">
                            Add Golfers To Outing
                        </b-button>
                    </template>
                </b-modal>
                <b-modal id="edit-handicap" :title="'Edit Handicap for ' + golfer.name" v-model="editHandicap" @ok="updateHandicap" v-if="outing.id">
                    <b-form>
                        <b-form-group label="Handicap Index" label-for="index">
                            <b-form-input name="index" id="index" v-model="golfer.index" type="text" v-validate="{required: true, decimal: 1, max_value: 36, min_value: 0}"></b-form-input>
                            <span class="text-danger">{{veeErrors.first('index')}}</span>
                        </b-form-group>
                    </b-form>
                    <template slot="modal-footer" slot-scope="{ ok, close }">
                        <b-button variant="secondary" @click="close()">
                            Cancel
                        </b-button>
                        <b-button variant="primary" @click="ok()">
                            Update Handicap
                        </b-button>
                    </template>
                </b-modal>
            </b-form>
        </div>
    </div>
</template>
<script>
    import axios from 'axios'
    import ArrowLeftIcon from "vue-material-design-icons/ArrowLeft";
    import ContentSaveIcon from "vue-material-design-icons/ContentSave";
    import PlusCircleIcon from "vue-material-design-icons/PlusCircle";
    import TrashCanIcon from "vue-material-design-icons/TrashCan";
    import PencilIcon from "vue-material-design-icons/Pencil";
    export default {
        components: {PencilIcon, TrashCanIcon, PlusCircleIcon, ContentSaveIcon, ArrowLeftIcon},
        data() {
            return {
                outing: { organizer: { id: 0}, course: { id: 0 } },
                loading: true,
                error: false,
                success: false,
                loadError: null,
                courses: [],
                golfers: [],
                outingGolfers: [],
                addToOuting: false,
                addGolfers:[],
                golfer: {id: null, name: null, index:0},
                editHandicap: false,
                allGolfers : []
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

                let self = this;
                self.loading = true;
                self.error = null
                axios.get('/outing/' + self.$route.params.id,{
                    headers: {
                        token: self.$store.state.token
                    },
                })
                    .then( result => {
                        self.loading = false;
                        if( result.status == 200 && result.data.success ){
                            if( result.data.outing.id ){
                                self.outing = result.data.outing;
                            }
                            self.outingGolfers = [];
                            self.golfers = result.data.allGolfers;
                            self.allGolfers = result.data.allGolfers;
                            self.outingGolfers = result.data.outingGolfers ? result.data.outingGolfers : [];
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
                axios.get('/course/list',{
                    headers: {
                        token: self.$store.state.token
                    },
                })
                    .then( result => {
                        if( result.status == 200 && result.data.success ){
                            self.courses = result.data.courses;
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
                        //this.outing.date =  this.$moment( this.outing.date ).format( 'YYYY-MM-DD');
                        if( this.outing.teeTime.length > 8 ){
                            this.outing.teeTime =  this.$moment( this.outing.teeTime ).format( 'HH:mm:ss');
                        }

                        let self = this;
                        axios({
                            method: ( this.outing.id ) ? 'PUT' : 'POST',
                            url: '/outing',
                            data: this.outing ,
                            headers: {
                                token: self.$store.state.token
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
            },
            putGolfers( e ){
                e.preventDefault();
                let self = this;
                if( this.addGolfers.length > 0 ){
                    axios({
                        method: 'POST',
                        url: '/api/addToOuting',
                        data: {outing: this.outing, golfers: this.addGolfers },
                        headers: {
                            token: self.$store.state.token
                        },
                        responseType: 'json'
                    }).then( result => {
                        if( result.data.success ){
                            self.golfers = result.data.golfers;
                            self.outingGolfers = result.data.outingGolfers;
                            this.addToOuting = false;
                        }
                    }, error => {
                        console.log( error );
                    })
                }
                else{
                    this.addToOuting = false
                }
            },
            openAddGolfers(){
                this.addGolfers = [];
                this.addToOuting = true;
            },
            removeGolfer( id ){
                let self = this;
                axios({
                    method: 'POST',
                    url: '/api/removeGolferFromOuting',
                    data: {id: id, outing: this.outing },
                    headers: {
                        token: self.$store.state.token
                    },
                    responseType: 'json'
                }).then( result => {
                    if( result.data.success ){
                        self.golfers = result.data.golfers;
                        self.outingGolfers = result.data.outingGolfers;
                    }
                }, error => {
                    console.log( error );
                })
            },
            openEdit(g){
                this.golfer = g;
                this.editHandicap = true;
            },
            updateHandicap( e ){
                e.preventDefault();
                this.$validator.validate().then(valid => {
                    if (valid ) {
                        let self = this;
                        axios({
                            method: 'POST',
                            url: '/api/updateHandicap',
                            data: {golfer: this.golfer },
                            headers: {
                                token: self.$store.state.token
                            },
                            responseType: 'json'
                        })
                            .then( result => {
                                console.log( result );
                                self.editHandicap = false;
                            }, error => {
                                console.log( error );
                            })
                    }
                });
            }
        }
    }
</script>