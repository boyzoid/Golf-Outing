<template>
    <div class="col-10 offset-1">
        <h1 class="text-center">Outing Scoring</h1>
        <loader v-if="loading"></loader>
        <div v-if="!loading">
            <b-link class="btn btn-outline-success mb-4 btn-sm" :to="{ name: 'outings'}">
                <arrow-left-icon></arrow-left-icon> Return to Outing List
            </b-link>
            <h2 class="text-center">{{ outing.date | moment('dddd MMMM D, YYYY')}}</h2>
            <h2 class="text-center">{{ course.name }}</h2>
            <h3 class="text-center">{{ course.city}}, {{course.state}}</h3>
            <table class="table table-hover scores">
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
                    <tr v-for="g in outingGolfers" class="golfers">
                        <th><b-link @click="scoreGolfer( g )" :title="'Edit Score for ' + g.name "><pencil-icon :size="14"></pencil-icon></b-link> {{g.name}} <span class="small">({{g.handicap}})</span></th>
                        <td v-for="p in $parent.lodash.range(1, 10)" class="text-center score" :class="getScoreClass(g.scores, p)">
                            {{ getGolferScore( g.scores, p) }}
                            <span class="pop" v-if="golferGetsPop(g.handicap, holes[p-1].handicap)">
                                <circle-icon :size="7" v-for="f in popsPerHole(g.handicap, holes[p-1].handicap)" :key="f"></circle-icon>
                            </span>
                        </td>
                        <td class="text-center table-secondary score" >{{g.score.front }}</td>
                        <td v-for="p in $parent.lodash.range(10, 19)" class="text-center score " :class="getScoreClass(g.scores, p)">
                            {{ getGolferScore( g.scores, p) }}
                            <span class="pop" v-if="golferGetsPop(g.handicap, holes[p-1].handicap)">
                                <circle-icon :size="7" v-for="b in popsPerHole(g.handicap, holes[p-1].handicap)" :key="b"></circle-icon>
                            </span>
                        </td>
                        <td class="text-center table-secondary score">{{g.score.back}}</td>
                        <td class="text-center table-info">{{ g.score.total }} <span v-if="g.score.total > 0"> ({{g.score.net}})</span></td>
                    </tr>
                </tbody>
            </table>
            <div v-if="Object.keys( skins ).length > 0" class="col-6 offset-3">
                <h3 class="text-center">Skins (Net)</h3>
                <table class="table table-striped table-hover">
                    <tbody>
                        <tr v-for="skin in skins">
                            <td>{{skin.name}} ({{skin.holes.length}}) ${{(((outingGolfers.length * 5)/totalSkins)*skin.holes.length).toFixed(2)}}</td>
                            <td>
                                <div v-for="hole in skin.holes">
                                    Hole: {{ hole.hole }} ( {{hole.score}} )
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
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
                        <b-form-input type="text" class="course-input mx-auto" :id="'s'+p" v-model="edit.scores[p-1].score" maxlength="2" ></b-form-input>
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
                handicapPrime: 0,
                totalSkins: 0
            }
        },
        created: function(){
            this.fetchOuting();
        },
        watch:{
            '$route' : 'fetchOuting',
            outingGolfers: function( n, o ){
                for( let i=0; i<n.length; i++ ){
                    n[i].handicap = this.courseHandicap( n[i].index);
                    n[i].score.net = n[i].score.total - n[i].handicap;
                }
                this.handicapPrime =  this.lodash.minBy(n, function(g){
                    return g.handicap;
                }).handicap;
            }
        },
        methods: {
            fetchOuting(){
                let self = this;
                self.loading = true;
                self.error = null
                axios.get('/api/outingdetails/id/' + self.$route.params.id,{

                })
                    .then( result => {
                        self.loading = false;
                        if( result.status == 200 && result.data.success ){
                            self.outing = result.data.outing;
                            self.course = result.data.course;
                            self.holes = result.data.holes;
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
            golferGetsPop( hcap, holeHandicap ){
                let hcap_prime = this.handicapPrime;
                return (hcap - hcap_prime) >= holeHandicap;
            },
            getScoreClass( scores, idx ){
                let ret = '';
                if( scores[idx] != undefined && scores[idx].relationToPar != undefined ){
                    switch( scores[idx].relationToPar ){
                        case -1:
                            ret = 'birdie';
                        break;
                        case -2:
                            ret = 'eagle';
                        break;
                    }
                }
                return ret
            },
            popsPerHole( hcap, holeHandicap ){
                let pops = hcap - this.handicapPrime;
                if( pops < 18  ){
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
                        this.edit.scores.push( {'id': this.holes[ score-1 ].id, 'score': golfer.scores[ score ].score != 0 ? golfer.scores[ score ].score : null })
                    }
                }
                else{
                    for( let i=0; i<18; i++ ){
                        this.edit.scores.push( {'id': this.holes[ i ].id, 'score': null})
                    }
                }

                this.$bvModal.show('edit-scores');
            },
            submitScores( e ){
                e.preventDefault();
                let self = this;
                axios({
                    method: 'POST',
                    url: '/api/postScore',
                    data: {id: self.outing.id, golferId: self.edit.outingGolferId, scores: self.edit.scores },

                    responseType: 'json'
                })
                    .then( result => {
                        self.outingGolfers = result.data.outingGolfers;
                        self.$bvModal.hide('edit-scores');
                    }, error => {
                        console.log( error );
                    })
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
            skins(){
                let ret = {};
                let lows = {};
                this.totalSkins = 0;
                for( let i=1; i<19; i++ ){
                    let low = 999;
                    let holeHandicap = this.holes[i-1].handicap;
                    for( let g=0; g<this.outingGolfers.length; g++ ){
                        let golfer = this.outingGolfers[g];
                        let hole = golfer.scores[i];
                        let netScore = hole.score;
                        if ( this.golferGetsPop( golfer.handicap, holeHandicap ) ){
                            netScore = netScore - this.popsPerHole( golfer.handicap, holeHandicap );
                        }
                        if( netScore > 0 && netScore == low ){
                            lows[i].push( {golfer: golfer.name, hole: i, score: netScore })
                        }
                        if( netScore > 0 && netScore < low ){
                            low = netScore;
                            lows[i] = [{id: golfer.id, name: golfer.name, hole: i, score: netScore }];
                        }
                    }

                    if(lows[i].length == 1 ){
                        let golfer = lows[i][0].name;
                        let id = lows[i][0].id
                        let score = lows[i][0].score;
                        let hole = lows[i][0].hole;
                        this.totalSkins = this.totalSkins + 1;
                        if( ret[id] == undefined ){
                            ret[id] = {name: golfer, holes: [ {hole: hole, score: score} ] }
                        }
                        else{
                            ret[id].holes.push( {hole: hole, score: score } )
                        }
                    }
                }
                return ret
            }

        }
    }
</script>