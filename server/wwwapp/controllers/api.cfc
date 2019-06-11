component accessors=true{
    property Any securityService;
    property Any courseService;
    property Any outingService;
    property Any golferService;

    function init(fw) {
        variables.fw = fw;
    }

    public function before( Any rc ){
        requestBody = toString( getHttpRequestData().content );
        if( isJSON( requestBody ) ){
            structAppend( rc, deserializeJSON(requestBody ) );
        }
        request.layout = false;

    }

    public function default( Any rc ){
                variables.fw.renderData().data( { "success" : false, 'error': 'Unauthorized access' } ).type( 'json' );
    }

    public function login( Any rc ){
        variables.fw.renderData().data( { "success" : true, 'token': createUUID() } ).type( 'json' );
    }

    public function courses( Any rc ){
        variables.fw.renderData().data( { "success" : true, 'courses': courseService.listCourses() } ).type( 'json' );
    }

    public function course( Any rc ){
        param name="rc.id" default=0;
        variables.fw.renderData().data( { "success" : true, 'course': courseService.getCourse( rc.id ), 'holes': courseService.getCourseHoles( rc.id ) } ).type( 'json' );
    }

    public function putCourse( Any rc ){
        var data = courseService.putCourse( rc.course, rc.holes );
        variables.fw.renderData().data( { "success": true, "course": data.course, 'holes': data.holes } ).type( 'json' );
    }

    public function outings( Any rc ){
        variables.fw.renderData().data( { "success" : true, 'outings': outingService.listOutings() } ).type( 'json' );
    }

    public function outing( Any rc ){
        param name="rc.id" default=0;
        variables.fw.renderData().data( { "success" : true, 'outing': outingService.getOuting( rc.id ) } ).type( 'json' );
    }

    public function putOuting( Any rc ){
        var outing = outingService.putOuting( rc.outing );
        variables.fw.renderData().data( { "success": true, "outing": outing } ).type( 'json' );
    }

    public function golfers( Any rc ){
        variables.fw.renderData().data( { "success" : true, 'golfers': golferService.listGolfers() } ).type( 'json' );
    }
}