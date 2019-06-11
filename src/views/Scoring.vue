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
            <b-button class="mb-3" @click="setUpScoreEntry()">Add Golfer Scores</b-button>
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
                        <th><b-link @click="rescoreGolfer( g )" :title="'Edit Score for ' + g.name "><pencil-icon :size="14"></pencil-icon></b-link> {{g.name}} <span class="small">({{courseHandicap(g.index)}})</span></th>
                        <td v-for="p in $parent.lodash.range(1, 10)" class="text-center">{{ getGolferScore( g.scores, p) }}<circle-icon :size="8" v-if="golferGetsPop(g.index, holes[p-1].handicap)"></circle-icon></td>
                        <td class="text-center">{{g.score.front}}</td>
                        <td v-for="p in $parent.lodash.range(10, 19)" class="text-center">{{ getGolferScore( g.scores, p) }}<circle-icon :size="8" v-if="golferGetsPop(g.index, holes[p-1].handicap)"></circle-icon></td>
                        <td class="text-center">{{g.score.back}}</td>
                        <td class="text-center">{{ g.score.front + g.score.back}}</td>
                    </tr>
                </tbody>
            </table>
        </div>
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
                golfers: [],
                outingGolfers: [],
                edit:{
                    golferId: null,
                    outingGolferId: null,
                    scores: []
                },
                showEntryModal: false
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
                            self.golfers = result.data.golfers;
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
            setUpScoreEntry(){
                this.edit.golferId = null;
                this.edit.scores = [];
                this.edit.outingGolferId = null;
                for( let i=0; i<this.holes.length; i++){
                    this.edit.scores.push( {'id': this.holes[i].id, 'score': null})
                }
                this.showEntryModal = true;
                console.log( this.edit );

            },
            rescoreGolfer( golfer ){
                this.edit.golferId = golfer.golferId;
                this.edit.outingGolferId = golfer.id;
                this.edit.scores = [];
                for( let score in golfer.scores ){
                    this.edit.scores.push( {'id': this.holes[ score-1 ].id, 'score': golfer.scores[ score ].score})
                }
                this.showEntryModal = true;
                console.log( this.edit );
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
            },
            handicapPrime(){
                let self = this;
                return this.lodash.maxBy( this.outingGolfers, function(g){
                    return self.courseHandicap( g.index );
                })
            }

        }
    }
</script>