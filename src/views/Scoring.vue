<template>
    <div class="col-12">
        <h1 class="text-center">Outing Scoring</h1>
        <loader v-if="loading"></loader>
        <div v-if="!loading">
            <b-link class="btn btn-outline-success mb-4 btn-sm" :to="{ name: 'outings'}">
                <arrow-left-icon></arrow-left-icon> Return to Outing List
            </b-link>
            <h2 class="text-center">{{ outing.date | moment('dddd MMMM D, YYYY')}}</h2>
            <h2 class="text-center">{{ course.name }}</h2>
            <h3 class="text-center">{{ course.city}}, {{course.state}}</h3>
            <div class="table-responsive">
            <table class="table table-sm table-striped scores">
                <thead>
                    <tr>
                        <th class="golfer-score"></th>
                        <th v-for="p in this.lodash.range(1, 10)" class="text-center">{{p}}</th>
                        <th></th>
                        <th v-for="p in this.lodash.range(10, 19)" class="text-center">{{p}}</th>
                        <th></th>
                        <th class="final-score"></th>
                    </tr>
                    <tr>
                        <th class="golfer-score">Handicap</th>
                        <th v-for="p in this.lodash.range(1, 10)" class="text-center">{{holes[p-1].handicap}}</th>
                        <th></th>
                        <th v-for="p in this.lodash.range(10, 19)" class="text-center">{{holes[p-1].handicap}}</th>
                        <th></th>
                        <th class="final-score"></th>
                    </tr>
                    <tr>
                        <th class="golfer-score">Par</th>
                        <th v-for="p in this.lodash.range(1, 10)" class="text-center">{{holes[p-1].par}}</th>
                        <th class="text-center">{{courseFrontNine}}</th>
                        <th v-for="p in this.lodash.range(10, 19)" class="text-center">{{holes[p-1].par}}</th>
                        <th class="text-center">{{courseBackNine}}</th>
                        <th class="text-center final-score">{{ courseFrontNine + courseBackNine }}</th>
                    </tr>

                </thead>
                <tbody>
                    <tr v-for="g in outingGolfers" class="golfers">
                        <th class="golfer-score"><b-link @click="scoreGolfer( g )" :title="'Edit Score for ' + g.name "><pencil-icon :size="14"></pencil-icon></b-link> {{g.name}} ({{g.handicap}})</th>
                        <td v-for="p in $parent.lodash.range(1, 10)" class="text-center score" :class="getScoreClass(g.scores, p)">
                            {{ getGolferScore( g.scores, p) }}
                            <span class="pop" v-if="golferGetsPop(g.handicap, holes[p-1].handicap)">
                                <circle-icon :size="7" v-for="f in popsPerHole(g.handicap, holes[p-1].handicap)" :key="f"></circle-icon>
                            </span>
                        </td>
                        <td class="text-center table-secondary score bold" >{{g.score.front }}</td>
                        <td v-for="p in $parent.lodash.range(10, 19)" class="text-center score " :class="getScoreClass(g.scores, p)">
                            {{ getGolferScore( g.scores, p) }}
                            <span class="pop" v-if="golferGetsPop(g.handicap, holes[p-1].handicap)">
                                <circle-icon :size="7" v-for="b in popsPerHole(g.handicap, holes[p-1].handicap)" :key="b"></circle-icon>
                            </span>
                        </td>
                        <td class="text-center table-secondary score bold">{{g.score.back}}</td>
                        <td class="text-center table-info bold final-score">{{ g.score.total }} <span v-if="g.score.total > 0"> ({{g.score.net}})</span></td>
                    </tr>
                </tbody>
            </table>
            </div>

            <h3 class="text-center">Teams <b-link class="ml-2" title="Add Team" @click="openTeam()"><plus-circle-icon title="Add Team"></plus-circle-icon></b-link></h3>
            <div v-if="outing.teams.length > 0">
                <div class="table-responsive">
                <table class="table table-striped table-hover table-sm">
                    <thead>
                    <tr>
                        <th class="golfer-score"></th>
                        <th v-for="p in this.lodash.range(1, 10)" class="text-center">{{p}}</th>
                        <th></th>
                        <th v-for="p in this.lodash.range(10, 19)" class="text-center">{{p}}</th>
                        <th></th>
                        <th></th>
                    </tr>
                    <tr>
                        <th class="golfer-score">Handicap</th>
                        <th v-for="p in this.lodash.range(1, 10)" class="text-center">{{holes[p-1].handicap}}</th>
                        <th></th>
                        <th v-for="p in this.lodash.range(10, 19)" class="text-center">{{holes[p-1].handicap}}</th>
                        <th></th>
                        <th></th>
                    </tr>
                    <tr>
                        <th class="golfer-score">Par</th>
                        <th v-for="p in this.lodash.range(1, 10)" class="text-center">{{holes[p-1].par}}</th>
                        <th class="text-center">{{courseFrontNine}}</th>
                        <th v-for="p in this.lodash.range(10, 19)" class="text-center">{{holes[p-1].par}}</th>
                        <th class="text-center">{{courseBackNine}}</th>
                        <th class="text-center">{{ courseFrontNine + courseBackNine }}</th>
                    </tr>

                    </thead>
                    <tbody>
                    <tr v-for="(t, idx) in outing.teams">
                        <th class="align-middle golfer-score">
                            <b-link @click="removeTeam(idx)" class="text-danger"><trash-can-icon title="Remove Team"></trash-can-icon> </b-link>
                            {{t.name.join(' - ')}}
                        </th>
                        <td v-for="p in $root.lodash.range(1, 10)" class="text-center align-middle score">{{getTeamScoreForHole(t,p)}}</td>
                        <td class="text-center table-secondary score align-middle bold score" >{{ t.totals.front}}</td>
                        <td v-for="p in $root.lodash.range(10, 19)" class="text-center align-middle score">{{getTeamScoreForHole(t,p)}}</td>
                        <td class="text-center table-secondary score align-middle bold score" >{{t.totals.back}}</td>
                        <td class="text-center table-info score align-middle bold score" >{{t.totals.total}}</td>
                    </tr>
                    </tbody>
                </table>
                </div>
            </div>
            <div v-if="outing.teams.length == 0" >
                <b-alert variant="info" show class="text-center">There are no teams configured.</b-alert>
            </div>
            <b-modal id="edit-teams" title="Set Team" @ok="setTeam" v-model="editTeams">
                <b-form>
                    <b-alert variant="info" :show="outingGolfers.length == 0">
                        <p>There are no available golfers to add.</p>
                    </b-alert>
                    <b-form-group label="Golfers" label-for="Golfers" v-if="outingGolfers.length > 0">
                        <b-form-select v-model="team"  id="golfers" name="golfers" placeholder="Choose golfers" multiple>
                            <option v-for="golfer in outingGolfers" :value="golfer">{{golfer.name}}</option>
                        </b-form-select>
                    </b-form-group>
                </b-form>
                <template slot="modal-footer" slot-scope="{ ok, close }">

                    <b-button variant="secondary" @click="close()">
                        Cancel
                    </b-button>
                    <b-button  variant="success" @click="ok()">
                        Save Team
                    </b-button>

                </template>
            </b-modal>

            <div v-if="Object.keys( skins ).length > 0" >
                <h3 class="text-center">Skins (Net)</h3>
                <table class="table table-striped table-hover table-sm">
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
            <div class="mb-2 d-xl-none d-lg-none d-md-none">
                <b-form-group label="Quick scoring" description="Use this to enter scores quickly by entering scores for each hole with a space in between">
                    <b-form-textarea id="quickScore" v-model="quickScore" rows="1" max-rows="2"></b-form-textarea>
                    <div class="bold text-danger" v-if="quickScoresError">
                        {{quickScoresError}}
                    </div>
                </b-form-group>

                <b-button @click="setQuickScores">Set Scores</b-button>
            </div>
            <div class="table-responsive">
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
                            <b-form-input :tabindex="100+p" type="tel" class="course-input mx-auto" :id="'s'+p" v-model="edit.scores[p-1].score" maxlength="1" ></b-form-input>
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
                        <b-form-input :tabindex="100+p" type="tel" class="course-input mx-auto" :id="'s'+p" v-model="edit.scores[p-1].score" maxlength="2" ></b-form-input>
                    </td>
                </tr>
                </tbody>
            </table>
            </div>
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
    import PlusCircleIcon from "vue-material-design-icons/PlusCircle";
    import TrashCanIcon from "vue-material-design-icons/TrashCan";
    export default{
        components: {TrashCanIcon, PlusCircleIcon, PencilIcon,  CircleIcon, ArrowLeftIcon},
        data(){
            return {
                loading: true,
                error: null,
                outing: {id: 0, teams: []},
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
                totalSkins: 0,
                editTeams: false,
                team:[],
                teamIdx: -1,
                teamScores:[],
                quickScore: null,
                quickScoresError: null
            }
        },
        created: function(){
            this.fetchOuting();
        },
        watch:{
            '$route' : 'fetchOuting',
            outingGolfers: function( n, o ){
               if( n.length > 0 ){
                   for( let i=0; i<n.length; i++ ){
                       n[i].handicap = this.courseHandicap( n[i].index);
                       n[i].score.net = n[i].score.total - n[i].handicap;
                   }
                   this.handicapPrime =  this.lodash.minBy(n, function(g){
                       return g.handicap;
                   }).handicap;
               }

            }
        },
        methods: {
            fetchOuting(){
                let self = this;
                self.loading = true;
                self.error = null
                axios.get('/outingdetails/' + self.$route.params.id,{
                    headers: {
                        token: self.$store.state.token
                    },
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
                if( !this.golferGetsPop( hcap, holeHandicap ) ){
                    return 0;
                }
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
                this.quickScore = null;
                this.quickScoresError = null
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
                    url: '/postScore',
                    data: {id: self.outing.id, golferId: self.edit.outingGolferId, scores: self.edit.scores },
                    headers: {
                        token: self.$store.state.token
                    },
                    responseType: 'json'
                })
                    .then( result => {
                        self.outingGolfers = result.data.outingGolfers;
                        self.$bvModal.hide('edit-scores');
                    }, error => {
                        console.log( error );
                    })
            },
            openTeam( ){
                this.team=[];
                this.editTeams = true;
            },
            setTeam( e ){
                e.preventDefault();
                let team = {name: [], scores: [], totals: {front: 0, back: 0, total: 0} };

                for( let i=0; i<this.team.length; i++ ){
                    let golfer = this.team[ i ];
                    team.name.push( golfer.name );
                }
                for( let j=0; j<18; j++){
                    let netScore = 99;
                    for( let k=0; k<this.team.length; k++ ){
                        let golfer = this.team[k];
                        let golferScore = golfer.scores[ j+1 ].score;
                        let pops = this.popsPerHole( golfer.handicap, this.holes[j].handicap );
                        if( (golferScore - pops) < netScore ){
                            netScore = golferScore - pops;
                        }

                    }
                    if( netScore == 99 ){
                        netScore = 0
                    }
                    team.scores.push( netScore );
                    team.totals.total = team.totals.total + netScore;
                    if( j < 10 ){
                        team.totals.front = team.totals.front + netScore;
                    }
                    else{
                        team.totals.back = team.totals.back + netScore;
                    }
                }
                if( this.teamIdx < 0 ){
                    this.outing.teams.push( team );
                }
                else{
                    this.outing.teams[ this.teamIdx ] = team;
                }
                this.editTeams = false;
                this.teamIdx = -1;
                this.team = [];
                this.saveTeams();
            },
            getTeamScoreForHole( team, hole ){
                let ret = 0;
                if( team.scores != undefined && team.scores[hole-1] != undefined ){
                    ret = team.scores[hole-1]
                }
                return ret;
            },
            removeTeam( idx ){
                if( this.outing.teams[idx] != undefined ){
                    this.outing.teams.splice( idx, 1 );
                    this.saveTeams();
                }
            },
            setQuickScores(){
                let scores = this.quickScore.split(' ');
                this.quickScoresError = null;
                if( scores.length <= this.edit.scores.length ){
                    for( let i=0; i<scores.length; i++ ){
                        this.edit.scores[i].score = scores[i]
                    }
                    this.quickScore = null;
                }
                else{
                    this.quickScoresError = 'You have entered more scores than there are holes, Please check the scores and try again.';
                }
            },
            saveTeams(){
                let self = this;
                axios({
                    method: 'POST',
                    url: '/putOutingTeams',
                    data: {id: self.outing.id, teams: self.outing.teams },
                    headers: {
                        token: self.$store.state.token
                    },
                    responseType: 'json'
                })
                    .then( result => {

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
                if( this.outingGolfers.length > 0 ){

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

                    if(lows[i] != undefined && lows[i].length == 1 ){
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
                }
                return ret
            }

        }
    }
</script>