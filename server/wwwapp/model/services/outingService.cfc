component accessors=true{

    public function listOutings(){
        var outings = queryExecute('select o.id, o.date, o.tee_time, o.golfer_count, c.name, c.city,c.state, u.first_name, u.last_name, u.email_address
        from outing o
        join course c on o.course_id = c.id
        join golfer u on o.managed_by = u.id
        order by o.date, o.tee_time');
        var ret = [];
        for( var outing in outings ){
            ret.append({ 'id': outing.id, 'date': outing.date, 'teeTime': outing.tee_time, 'count': outing.golfer_count, 'course': {'name': outing.name, 'location': outing.city & ', ' & outing.state}, 'manager': { 'name': outing.first_name & ' ' & outing.last_name, 'email': outing.email_address}});
        }
        return ret;
    }

    public function getOuting( numeric id=0 ){
        var outing = queryExecute('select id, date, tee_time, golfer_count, course_id, managed_by from outing where id = :id', { id: id } );
        return { 'id': outing.id, 'date': dateTimeFormat( outing.date, 'yyyy-mm-dd' ) , 'teeTime': isdate( outing.tee_time ) ? dateTimeFormat( outing.tee_time, 'yyyy-mm-dd' ) & 'T' & dateTimeFormat( outing.tee_time, 'hh:nn:ss.lll') : '', 'count': outing.golfer_count, 'courseId': outing.course_id, 'organizer': outing.managed_by };
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

    private function addOuting( outing ){
        outing.teeTime = timeFormat( replaceNoCase(outing.teeTime, 'T', ' '), 'hh:mm:ss');
        outing.date = dateformat( replaceNoCase( outing.date, 'T', ' '), 'yyyy-mm-dd');
        queryExecute( 'insert into outing( date, tee_time, managed_by, course_id, golfer_count ) values( :date, :teeTime, :organizer, :courseId, :count )',
        { date: outing.date, teeTime: outing.teeTime, organizer: outing.organizer, courseId: outing.courseId, count: outing.count },
        {result: 'result'}  );
        return getOuting( result.generatedKey );
    }

    private function updateOuting( outing ){
        outing.teeTime = timeFormat( replaceNoCase(outing.teeTime, 'T', ' '), 'hh:mm:ss');
        outing.date = dateformat( replaceNoCase( outing.date, 'T', ' '), 'yyyy-mm-dd');
        queryExecute( 'update outing set date = :date, tee_time = :teeTime, managed_by = :organizer, course_id = :courseId, golfer_count = :count where id = :id',
        { id: outing.id, date: outing.date, teeTime: outing.teeTime, organizer: outing.organizer, courseId: outing.courseId, count: outing.count });
        return getOuting( outing.id );
    }
}