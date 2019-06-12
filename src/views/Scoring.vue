<template>
    <div class="col-8 offset-2">
        <h1 class="text-center">Outing Scoring</h1>
        <loader v-if="loading"></loader>
        <div v-if="!loading">
            <b-link class="btn btn-outline-success mb-4 btn-sm" :to="{ name: 'outings'}">
                <arrow-left-icon></arrow-left-icon> Return to Outing List
            </b-link>
            <h2 class="text-center">{{ outing.date | moment('dddd MMMM D, YYYY')}}</h2>
            <h2 class="text-center">{{ course.name }}</h2>
            <h3 class="text-center">{{ course.city}}, {{course.state}}</h3>

            <table class="table table-striped scores">
                <thead>
                    <tr>
                        <th></th>
                        <th v-for="p in this.lodash.range(1, 10)" class="text-center">{{p}}</th>
                        <th></th>
                        <th v-for="p in this.lodash.range(10, 19)" class="text-center">{{p}}</th>
                        <th></th>
                        <th></th>
                    </tr>
                    <tr>
                        <th>Handicap</th>
                        <th v-for="p in this.lodash.range(1, 10)" class="text-center">{{holes[p-1].handicap}}</th>
                        <th></th>
                        <th v-for="p in this.lodash.range(10, 19)" class="text-center">{{holes[p-1].handicap}}</th>
                        <th></th>
                        <th></th>
                    </tr>
                    <tr>
                        <th>Par</th>
                        <th v-for="p in this.lodash.range(1, 10)" class="text-center">{{holes[p-1].par}}</th>
                        <th class="text-center">{{courseFrontNine}}</th>
                        <th v-for="p in this.lodash.range(10, 19)" class="text-center">{{holes[p-1].par}}</th>
                        <th class="text-center">{{courseBackNine}}</th>
                        <th class="text-center">{{ courseFrontNine + courseBackNine }}</th>
                    </tr>

                </thead>
                <tbody>
                    <tr v-for="g in outingGolfers">
                        <th><b-link @click="scoreGolfer( g )" :title="'Edit Score for ' + g.name "><pencil-icon :size="14"></pencil-icon></b-link> {{g.name}} <span class="small">({{courseHandicap(g.index)}})</span></th>
                        <td v-for="p in $parent.lodash.range(1, 10)" class="text-center">
                            {{ getGolferScore( g.scores, p) }}
                            <span class="pop" v-if="golferGetsPop(g.index, holes[p-1].handicap)">
                                <circle-icon :size="7" v-for="f in popsPerHole(g.index, holes[p-1].handicap)" :key="f"></circle-icon>
                            </span>
                        </td>
                        <td class="text-center table-info" >{{g.score.front }}</td>
                        <td v-for="p in $parent.lodash.range(10, 19)" class="text-center">
                            {{ getGolferScore( g.scores, p) }}
                            <span class="pop" v-if="golferGetsPop(g.index, holes[p-1].handicap)">
                                <circle-icon :size="7" v-for="b in popsPerHole(g.index, holes[p-1].handicap)" :key="b"></circle-icon>
                            </span>
                        </td>
                        <td class="text-center table-info">{{g.score.back}}</td>
                        <td class="text-center table-warning">{{ g.score.front + g.score.back }}</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <b-modal id="edit-scores" title="Enter Scores" size="xl" @ok="submitScores">
            <h4>{{course.name}}</h4>
            <h5>{{edit.name}}</h5>
            <table class="table table-sm">
                <thead>
                    <tr>
                        <th>Hole</th>
                        <th v-for="p in this.lodash.range(1, 10)" class="text-center">{{p}}</th>
                    </tr>
                    <tr>
                        <th>Par</th>
                        <th v-for="p in this.lodash.range(1, 10)" class="text-center">{{holes[p-1] != undefined ? holes[p-1].par : ''}}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td></td>
                        <td v-for="p in lodash.range( 1, 10)" class="text-center">
                            <b-form-input type="text" class="course-input mx-auto" :id="'s'+p" v-model="edit.scores[p-1].score" maxlength="1" ></b-form-input>
                        </td>
                    </tr>
                </tbody>
                <thead>
                <tr>
                    <th>Hole</th>
                    <th v-for="p in this.lodash.range(10, 19)" class="text-center">{{p}}</th>
                </tr>
                <tr>
                    <th>Par</th>
                    <th v-for="p in this.lodash.range(10, 19)" class="text-center">{{holes[p-1] != undefined ? holes[p-1].par : ''}}</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td></td>
                    <td v-for="p in lodash.range( 10, 19)" class="text-center">
                        <b-form-input type="text" class="course-input mx-auto" :id="'s'+p" v-model="edit.scores[p-1].score" maxlength="1" ></b-form-input>
                    </td>
                </tr>
                </tbody>
            </table>
            <template slot="modal-footer" slot-scope="{ ok, close }">

                <b-button variant="secondary" @click="close()">
                    Cancel
                </b-button>
                <b-button  variant="success" @click="ok()">
                    Save Round
                </b-button>

            </template>
        </b-modal>
    </div>

</template>
<script>
    import axios from 'axios'
    import ArrowLeftIcon from "vue-material-design-icons/ArrowLeft";
    import StarIcon from "vue-material-design-icons/Star";
    import CircleIcon from "vue-material-design-icons/Circle";
    import CircleSmallIcon from "vue-material-design-icons/CircleSmall";
    import CircleMediumIcon from "vue-material-design-icons/CircleMedium";
    import PencilIcon from "vue-material-design-icons/Pencil";
    export default{
        components: {PencilIcon, CircleMediumIcon, CircleSmallIcon, CircleIcon, StarIcon, ArrowLeftIcon},
        data(){
            return {
                loading: true,
                error: null,
                outing: {id: 0},
                course: {},
                holes: [],
                outingGolfers: [],
                edit: {
                    name: null,
                    golferId: null,
                    outingGolferId: null,
                    scores: [
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                        {id: null, score: null},
                    ]
                },
                handicapPrime: 0
            }
        },
        created: function(){
            this.fetchOuting();
        },
        watch:{
            '$route' : 'fetchOuting'
        },
        methods: {
            fetchOuting(){
                let self = this;
                self.loading = true;
                self.error = null
                axios.get('/api/outingdetails/id/' + self.$route.params.id,{
                    headers: {
                        'token': self.$store.state.token
                    },
                })
                    .then( result => {
                        self.loading = false;
                        if( result.status == 200 && result.data.success ){
                            self.outing = result.data.outing;
                            self.course = result.data.course;
                            self.holes = result.data.holes;
                            self.outingGolfers = result.data.outingGolfers;

                            self.handicapPrime = self.courseHandicap(this.lodash.minBy( self.outingGolfers, function(g){
                                return self.courseHandicap( g.index );
                            }).index)
                        }
                        else{
                            self.loadError = "There was a problem loading the outing."
                        }
                    }, error => {
                        console.log( error );
                        self.loadError = "There was a problem loading the outing."
                    })
            },
            courseHandicap( idx ){
                return  Math.round( ( idx * this.course.slope ) / 113 );
            },
            getGolferScore( scores, idx ){
                let ret = '';
                if( scores[ idx ] != undefined && scores[idx].score != undefined ){
                    ret = scores[ idx ].score;
                }
                return ret;
            },
            golferGetsPop( idx, holeHandicap ){
                let hcap = this.courseHandicap( idx );
                let hcap_prime = this.handicapPrime;
                return (hcap - hcap_prime) >= holeHandicap;
            },
            popsPerHole( idx, holeHandicap ){
                let hcap = this.courseHandicap( idx );
                let pops = hcap - this.handicapPrime;
                if( pops < 18 && this.golferGetsPop( idx, holeHandicap ) ){
                    return 1
                }
                if( pops > 18 && pops-18 >= holeHandicap  ){
                    return 2
                }
                else{
                    return 1
                }

            },
            scoreGolfer( golfer ){
                this.edit.golferId = golfer.golferId;
                this.edit.outingGolferId = golfer.id;
                this.edit.name = golfer.name;
                this.edit.scores = [];
                if( Object.keys( golfer.scores ).length > 0 ){
                    for( let score in golfer.scores ){
                        this.edit.scores.push( {'id': this.holes[ score-1 ].id, 'score': golfer.scores[ score ].score})
                    }
                }
                else{
                    for( let i=0; i<18; i++ ){
                        this.edit.scores.push( {'id': this.holes[ i ].id, 'score': null})
                    }
                }

                this.$bvModal.show('edit-scores');
                console.log( this.edit );
            },
            submitScores( e ){
                e.preventDefault();
                console.log( 'submitted' );
            }
        },
        computed:{
            courseFrontNine(){
                let ret = 0;
                for( let i=0; i<9; i++ ){
                    ret = ret + this.holes[i].par
                }
                return ret;
            },
            courseBackNine(){
                let ret = 0;
                for( let i=9; i<18; i++ ){
                    ret = ret + this.holes[i].par
                }
                return ret;
            }

        }
    }
</script>