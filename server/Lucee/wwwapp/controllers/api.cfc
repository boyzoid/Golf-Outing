component accessors=true{
    property Any securityService;
    property Any courseService;
    property Any outingService;
    property Any golferService;
    property Any securityService;

    function init(fw) {
        variables.fw = fw;
    }

    public function before( Any rc ){
        var req = getHTTPRequestData();
        rc.token = '';
        request.layout = false;
        var method = variables.fw.getCGIRequestMethod();
        if( method != 'OPTIONS' && rc.action != 'api.default' && rc.action != 'api.login' ){
            var headers = req.headers;
            if( structKeyExists( headers, 'token' ) && securityService.verifyToken( headers.token ) ){
               rc.token = securityService.renewToken( headers.token );
            }
            else{
                var currentContext = getPageContext().getResponse();
                    currentContext.setStatus( 401, 'Not authenticated');
                abort;
            }
        }
    }

    public function default( Any rc ){

    }

    public function login( Any rc ){
        param name="rc.username" default='';
        param name="password" default='';
        var token = '';
        var success = false;
        var loginAttempt = securityService.login( rc.username, rc.password );
        if(  loginAttempt.success ){
            token = loginAttempt.token;
            success = true;
        }
        variables.fw.renderData().data( { 'success' : success, 'token': token } ).type( 'json' );
    }

    public function courses( Any rc ){
        variables.fw.renderData().data( { 'success' : true, 'courses': courseService.listCourses(), 'token': rc.token  } ).type( 'json' );
    }

    public function course( Any rc ){
        param name='rc.id' default=0;
        var course = courseService.getCourse( rc.id );
        course['holes'] = courseService.getCourseHoles( rc.id );
        variables.fw.renderData().data( { 'success' : true, 'course': course,  'token': rc.token  } ).type( 'json' );
    }

    public function putCourse( Any rc ){
        var course = courseService.putCourse( rc.course );
        variables.fw.renderData().data( { 'success' : true, 'course': course,  'token': rc.token  } ).type( 'json' );
    }

    public function outings( Any rc ){
        variables.fw.renderData().data( { 'success' : true, 'outings': outingService.listOutings(), 'token': rc.token }  ).type( 'json' );
    }

    public function outing( Any rc ){
        param name='rc.id' default=0;
        var outing = outingService.getOuting( rc.id );
        outing[ 'golfers' ] = outingService.listOutingGolfers( rc.id )
        variables.fw.renderData().data( { 'success' : true, 'outing': outing, 'allGolfers': golferService.listGolfers() , 'availableGolfers' : golferservice.listGolfersForOuting( rc.id ) , 'token': rc.token  } ).type( 'json' );
    }

    public function putOuting( Any rc ){
        var outing = outingService.putOuting( rc.outing );
        variables.fw.renderData().data( { 'success': true, 'outing': outing, 'token': rc.token }  ).type( 'json' );
    }

    public function addToOuting( Any rc ){
        param name="rc.outing" default={ id : 0 };
        param name='rc.golfers' default=[];
        outingService.addGolfersToOuting( rc.outing.id, rc.golfers);
        variables.fw.renderData().data( { 'success': true, 'token': rc.token }  ).type( 'json' );
    }

    public function removeGolferFromOuting( Any rc ){
        param name='rc.id' default=0;
        outingService.removeGolferFromOuting( rc.id );
        variables.fw.renderData().data( { 'success': true, 'token': rc.token } ).type( 'json' );
    }

    public function outingDetails( Any rc ){
        param name='rc.id' default=0;
        var outing = outingService.getOuting( rc.id );
        outing.course = courseService.getCourse( outing.course.id );
        outing.course[ 'holes' ] = courseService.getCourseHoles( outing.course.id);
        var outingGolfers = outingService.listOutingGolfers( rc.id, true );
        variables.fw.renderData().data( { 'success': true, 'outing': outing, 'outingGolfers': outingGolfers, 'token': rc.token  } ).type( 'json' );
    }

    public function golfers( Any rc ){
        variables.fw.renderData().data( { 'success' : true, 'golfers': golferService.listGolfers(), 'token': rc.token  } ).type( 'json' );
    }

    public function putGolfer( Any rc ){
        param name="rc.golfer.id" default=0;
        param name="rc.golfer.nickname" default='';
        var result = golferService.putGolfer( rc.golfer );
        variables.fw.renderData().data( { 'success' : result.success, 'golfers': golferService.listGolfers(), 'token': rc.token  } ).type( 'json' );
    }

    public function updateHandicap( Any rc ){
        param name='rc.golfer' default={id: 0, index: 0 };
        outingService.updateGolferHandicap( rc.golfer );
        variables.fw.renderData().data( { 'success' : true, 'token': rc.token  } ).type( 'json' );
    }

    public function postScore( Any rc ){
        param name='rc.id' default=0;
        param name='rc.golferid' default=0;
        param name='rc.scores' default=[];
        outingService.postScore( rc.golferId, rc.scores );
        var outingGolfers = outingService.listOutingGolfers( rc.id, true );
        variables.fw.renderData().data( { 'success' : true, 'outingGolfers': outingGolfers, 'token': rc.token  } ).type( 'json' );
    }

    public function putOutingTeams( Any rc ){
        param name="rc.id" default=0;
        param name="rc.teams" default=[];
        outingService.putOutingTeams( rc.id, rc.teams );
        variables.fw.renderData().data( { 'success' : true, 'token': rc.token  } ).type( 'json' );
    }
}