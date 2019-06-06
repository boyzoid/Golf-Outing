component accessors=true{
    property Any securityService;
    property Any courseService;

    function init(fw) {
        variables.fw = fw;
    }

    public function before( Any rc ){
        cfheader( name="Access-Control-Allow-Origin", value="*");
        cfheader( name="Access-Control-Allow-Headers", value="Content-Type, Access-Control-Allow-Headers, X-Requested-With, token, content-type");
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
}