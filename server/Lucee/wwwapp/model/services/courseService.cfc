component accessors=true{
    public function listCourses(){
        var courses = queryExecute('select id, name, city, state, slope, rating from course order by name');
        var ret = [];
        for( var course in courses ){
            ret.append({ 'id': course.id,  'name': course.name, 'city': course.city, 'state': course.state, 'slope': course.slope, 'rating': course.rating } );
        }
        return ret;
    }

    public function getCourse( numeric id ){
        var course = queryExecute('select id, name, city, state, slope, rating from course where id = :id', {id: id } );
        var ret = { 'id': 0, 'name': '', 'city': '', 'state': '', 'slope': '', 'rating': ''};
        if( course.recordCount ){
            ret.id = course.id;
            ret.name = course.name;
            ret.city = course.city;
            ret.state = course.state;
            ret.slope = course.slope;
            ret.rating = course.rating;
        }
        return ret;
    }

    public function getCourseHoles( numeric id ){
        var ret = [];
        var holes = queryExecute('select id, number, par, handicap from hole where course_id = :id order by number', { id: id } );
        for( var hole in holes ){
            ret.append( { 'id': hole.id, 'number': hole.number, 'par': hole.par, 'handicap': hole.handicap } );
        }
        return ret;
    }

    public function putCourse( struct course ){
        var ret = {};
        if( course.id == 0 ){
            ret = addCourse( course );
        }
        else{
            ret = updateCourse( course );
        }
        ret['holes'] = putHoles( course.holes, course.id );
        return ret;
    }

    private function putHoles( array holes, numeric courseId ){
        for( var hole in holes ){
            if( isNull( hole.id ) ){
                hole.courseId = courseId;
                addHole( hole );
            }
            else{
                updateHole( hole );
            }
        }
        return getCourseHoles( courseId );
    }

    private function updateCourse( struct course ){
        queryExecute( ' update course set name = :name, city = :city, state = :state, slope = :slope, rating = :rating where id = :id', {id: course.id, name: course.name, city: course.city, state: ucase( course.state), slope: course.slope, rating:course.rating } );
        return getCourse( course.id );
    }

    private function addCourse( struct course ){
        queryExecute( 'insert into course ( name, city, state, slope, rating) values( :name, :city, :state, :slope, :rating)', {name: course.name, city: course.city, state: ucase( course.state), slope: course.slope, rating:course.rating }, {result: 'result'} );
        return getCourse( result.generatedKey );
    }

    private function updateHole( struct hole ){
        queryExecute('update hole set number= :number, par = :par, handicap =  :handicap where id = :id', { id: hole.id, number: hole.number, par: hole.par, handicap: hole.handicap});
    }

    private function addHole( struct hole ){
        queryExecute( 'insert into hole( number, par, handicap, course_id) values( :number, :par, :handicap, :courseid)', { courseId: hole.courseId, number: hole.number, par: hole.par, handicap: hole.handicap});
    }
}