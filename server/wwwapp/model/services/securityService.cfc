component accessors=true{
    property Any encryptionService;

    public function login( username, password ){
        var pwd = encryptionService.encrypt( password );
        var login = queryExecute('select id, email_address from golfer where email_address = :email and password = :pwd', {email: username, pwd: pwd });
        if( login.recordCount == 1 ) {
            return {'success': true, 'token': getAuthToken(login.id, login.email_address) };

        }
        else{
            return { 'success' : false, 'token': ''};
        }
    }

    public function verifyToken( string token ){
        var ret = false;
        try{
            var t = decryptAuthToken( token );
            if( t.expires > now() && isValidUser( val( t.id ), t.user) ) ret = true;
        }
        catch( any e ){
        writeDump( token );
        writeDump( var=e, abort=true)
            ret = false;
        }

        return ret;
    }

    public function renewToken( string token){
        var t = decryptAuthToken( token );
        return getAuthToken( t.id, t.user );
    }

    private function getAuthToken( id, username){
        var data = { id: id, user: username, expires: dateAdd('h', 1, now() ) };
        return encryptionService.encrypt( serializeJSON( data ) );
    }

    private function decryptAuthToken( token ){
        var data = encryptionService.decrypt( token );
        return deserializeJSON( data );
    }

    private function isValidUser( numeric id, string user ){
        var u = queryExecute('select id from golfer where id = :id and email_address = :user and active = 1', { id: id, user: user } );
        return u.recordCount == 1;
    }
}