component accessors=true{


    public function encrypt( string val ){
        return encrypt( val, '0j58zdMjKh3GbgASqPk8Fg==', 'AES', 'base64' );
    }

    public function decrypt( string val ){
        return decrypt( val, '0j58zdMjKh3GbgASqPk8Fg==', 'AES', 'base64' );
    }
}