<template>
    <div class="col-10 offset-1">
        <h1 class="text-center">Golfers</h1>
        <loader v-if="loading"></loader>
        <div v-if="!loading">
            <div class="overflow-auto" v-if="golfers.length > 0">
                <b-link class="btn btn-outline-primary btn-sm mb-2" @click="addGolfer()">
                    <plus-icon></plus-icon> Add Golfer
                </b-link>
                <b-pagination v-model="currentPage" :total-rows="rows" :per-page="perPage" aria-controls="course-table" v-if="rows > perPage"></b-pagination>
                <div class="table-responsive">
                    <b-table id="course-table" class="table-sm" :items="golfers" :fields="fields" :per-page="perPage" :current-page="currentPage" :striped="true" :hover="true">
                        <template slot="name" slot-scope="data">
                            {{ data.value.firstName }} {{ data.value.lastName }}
                        </template>
                        <template slot="actions" slot-scope="row">
                            <b-link class="btn btn-outline-primary btn-sm" :title="'Edit ' + row.item.name" @click="editGolfer( row.item )">
                                <pencil-icon></pencil-icon>
                            </b-link>
                        </template>
                    </b-table>
                </div>
            </div>
        </div>
        <b-modal id="edit-golfer" v-model="showEdit" @ok="putGolfer" :title="golfer.id ? 'Edit Golfer' : 'Add Golfer'">
            <b-alert :show="success" variant="success" dismissible>
                Golfer saved successfully.
            </b-alert>
            <b-alert :show="error" variant="danger" dismissible>
                {{ error }}
            </b-alert>
            <b-form>
                <b-form-group label="First Name" label-for="firstName">
                    <b-form-input name="firstName" data-vv-as="first name" id="firstname" v-model="golfer.firstName" type="text" v-validate="{required: true, max: 45}"></b-form-input>
                    <span class="text-danger">{{veeErrors.first('firstName')}}</span>
                </b-form-group>
                <b-form-group label="Last Name" label-for="lastName">
                    <b-form-input name="lastName" data-vv-as="last name" id="lastname" v-model="golfer.lastName" type="text" v-validate="{required: true, max: 45}"></b-form-input>
                    <span class="text-danger">{{veeErrors.first('lastName')}}</span>
                </b-form-group>
                <b-form-group label="Nickname" label-for="nickname">
                    <b-form-input name="nickname" data-vv-as="last name" id="nickname" v-model="golfer.nickname" type="text" v-validate="{max: 45}"></b-form-input>
                    <span class="text-danger">{{veeErrors.first('nickname')}}</span>
                </b-form-group>
                <b-form-group label="Email Address" label-for="email">
                    <b-form-input name="email" data-vv-as="email address" id="email" v-model="golfer.email" type="text" v-validate="{required: true, email: true, max: 100}"></b-form-input>
                    <span class="text-danger">{{veeErrors.first('email')}}</span>
                </b-form-group>
            </b-form>
        </b-modal>
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
                golfers: [],
                loading: true,
                error: null,
                success: false,
                perPage: 10,
                currentPage: 1,
                showEdit: false,
                golfer: {},
                fields: {
                    id:{
                        key: 'actions',
                        label: 'Actions'
                    },
                    fullname: {
                        label: 'Golfer Name'
                    },
                    nickname:{
                        label: 'Nickname'
                    },
                    email:{
                        label: 'Email'
                    }
                },
            }
        },
        created: function(){
            this.fetchGolfers()
        },
        watch: {
            '$route': 'fetchGolfers'
        },
        methods:{
            fetchGolfers(){
                let self = this;
                self.loading = true;
                axios.get('/api/golfers',{
                    headers: {
                        token: self.$store.state.token
                    },
                })
                    .then( result => {
                        self.loading = false;
                        if( result.status == 200 && result.data.success ){
                            self.golfers = result.data.golfers;
                        }
                        else{
                            self.error = "There was a problem loading the course list"
                        }
                    }, error => {
                        console.log( error );
                        self.error = "There was a problem loading the course list"
                    })
            },
            editGolfer( golfer ){
                this.golfer = golfer;
                this.error = false;
                this.success = false;
                this.showEdit = true;
            },
            addGolfer(){
                this.golfer = {};
                this.error = null;
                this.success = false;
                this.showEdit = true;
            },
            putGolfer( e ){
                e.preventDefault();
                console.log( this.golfer );
                this.success = false;
                this.error = null;
                this.$validator.validate().then(valid => {
                    if (valid  ) {
                        let self = this;
                        axios({
                            method: 'POST',
                            url: '/api/putGolfer',
                            data: {golfer: self.golfer },
                            headers: {
                                token: self.$store.state.token
                            },
                            responseType: 'json'
                        })
                            .then( result => {
                                if( result.data.success ){
                                    self.golfers = result.data.golfers;

                                    self.success = true;
                                }
                                else{
                                    console.log('failed')
                                    this.error = 'There was an issue saving the golfer';
                                }
                            }, error => {
                                console.log( error );
                                this.error = 'There was an issue saving the golfer';
                            })
                    }
                });
            }
        },
        computed :{
            rows(){
                return this.golfers.length;
            }
        }

    }
</script>