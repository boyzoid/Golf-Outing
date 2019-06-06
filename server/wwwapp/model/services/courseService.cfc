component accessors=true{
    public function listCourses(){
        var courses = queryExecute('select id, name, city, state, slope, rating from course order by name');
        var ret = [];
        for( var course in courses ){
            ret.append({ 'id': course.id,  'name': course.name, 'city': course.city, 'state': course.state, 'slope': course.slope, 'rating': course.rating } );
        }
        return ret;
    }
}