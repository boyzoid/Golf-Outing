component accessors=true{


    public function encrypt( string val ){
        return encrypt( val, '0j58zdMjKh3GbgASqPk8Fg==', 'AES', 'hex' );
    }

    public function decrypt( string val ){
        return decrypt( val, '0j58zdMjKh3GbgASqPk8Fg==', 'AES', 'hex' );
    }
    public function hash( string val ){
        return hash( val, "SHA-256", "UTF-8" );
    }
}