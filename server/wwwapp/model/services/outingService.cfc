component accessors=true{

    public function listOutings(){
        var outings = queryExecute('select o.scored, o.id, o.date, o.tee_time, c.name, c.city,c.state, u.first_name, u.last_name, u.email_address
        from outing o
        join course c on o.course_id = c.id
        join golfer u on o.managed_by = u.id
        where datediff( now(), o.date ) < 7
        order by o.scored desc, o.date, o.tee_time');
        var ret = [];
        for( var outing in outings ){
            ret.append({ 'id': outing.id, 'scored' : outing.scored == 0 ? false : true, 'date': outing.date, 'teeTime': outing.tee_time, 'course': {'name': outing.name, 'location': outing.city & ', ' & outing.state}, 'manager': { 'name': outing.first_name & ' ' & outing.last_name, 'email': outing.email_address}});
        }
        return ret;
    }

    public function getOuting( numeric id=0 ){
        var outing = queryExecute('select id, date, tee_time, course_id, managed_by from outing where id = :id', { id: id } );
        return { 'id': outing.id, 'date': dateTimeFormat( outing.date, 'yyyy-mm-dd' ) , 'teeTime': isdate( outing.tee_time ) ? dateTimeFormat( outing.tee_time, 'yyyy-mm-dd' ) & 'T' & dateTimeFormat( outing.tee_time, 'hh:nn:ss.lll') : '', 'courseId': outing.course_id, 'organizer': outing.managed_by };
    }

    public function putOuting( struct outing ){
        param name="outing.id" default=0;
        if( val( outing.id ) == 0 ){
            return addOuting( outing );
        }
        else{
            return updateOuting( outing );
        }
    }

    public function listOutingGolfers( numeric id, boolean returnScores=true ){
        var ret = [];
        var golfers = queryExecute("select og.id, og.golfer_id, concat(g.first_name, ' ' , last_name) golfer, g.nickname, og.handicap_index, h.number, h.par, h.handicap, gs.score
                                    from hole h
                                    join outing o on h.course_id = o.course_id
                                    join outing_golfer og on o.id = og.outing_id
                                    join golfer g on og.golfer_id = g.id
                                    left join golfer_score gs on og.id = gs.outing_golfer_id

                                    where o.id = :id
                                    order by g.last_name, g.first_name, h.number", { id: id });
        cfloop( query=golfers, group='golfer' ){
            var g = { 'name': golfers.golfer, 'index': golfers.handicap_index, 'scores' : {}, 'id': golfers.id, 'golferId': golfers.golfer_id, 'score' : {'front' : 0, 'back' :0} };
            cfloop(){
                    var score = val( golfers.score );
                    g.scores[golfers.number]= {
                        'score' : val( score ),
                        'relationToPar': score == 0 ? 0 : score - golfers.par ,
                    };
                    if( golfers.number < 10 ){
                        g.score.front = g.score.front + score;
                    }
                    else{
                        g.score.back = g.score.back + score;
                    }


            }
            ret.append( g );
        }
        return ret;
    }

    public function addGolfersToOuting( numeric id=0, array golfers ){
        for( var g in golfers ){
            queryExecute('insert into outing_golfer( golfer_id, outing_id)
                        select :golferId, :id
                        from dual
                        where not exists (select id from outing_golfer where golfer_id = :golferId and outing_id = :id)', {id: id, golferId: g });
        }
    }

    public function removeGolferFromOuting( numeric id=0 ){
        queryExecute( 'delete from golfer_score where outing_golfer_id = :id', { id : id } );
        queryExecute( 'delete from outing_golfer where id = :id ', { id : id } );
    }

    public function updateGolferHandicap( struct golfer ){
        queryExecute( 'update outing_golfer set handicap_index = :idx where id = :id ', { id: golfer.id, idx: golfer.index } );
    }

    private function addOuting( outing ){
        outing.teeTime = timeFormat( replaceNoCase(outing.teeTime, 'T', ' '), 'hh:mm:ss');
        outing.date = dateformat( replaceNoCase( outing.date, 'T', ' '), 'yyyy-mm-dd');
        queryExecute( 'insert into outing( date, tee_time, managed_by, course_id ) values( :date, :teeTime, :organizer, :courseId )',
        { date: outing.date, teeTime: outing.teeTime, organizer: outing.organizer, courseId: outing.courseId },
        {result: 'result'}  );
        return getOuting( result.generatedKey );
    }

    private function updateOuting( outing ){
        outing.teeTime = timeFormat( replaceNoCase(outing.teeTime, 'T', ' '), 'hh:mm:ss');
        outing.date = dateformat( replaceNoCase( outing.date, 'T', ' '), 'yyyy-mm-dd');
        queryExecute( 'update outing set date = :date, tee_time = :teeTime, managed_by = :organizer, course_id = :courseId where id = :id',
        { id: outing.id, date: outing.date, teeTime: outing.teeTime, organizer: outing.organizer, courseId: outing.courseId });
        return getOuting( outing.id );
    }
}