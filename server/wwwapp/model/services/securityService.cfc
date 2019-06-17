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

    private function getAuthToken( id, username){
        var data = { id: id, user: username, expires: dateAdd('h', 1, now() ) };
        return encryptionService.encrypt( serializeJSON( data ) );
    }

    private function decryptAuthToken( token ){
        var data = encryptionService.decrypt( token );
        return deserializeJSON( data );
    }
}