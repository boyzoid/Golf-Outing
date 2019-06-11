component accessors=true{

    public function listGolfers(){
        var ret = [];
        var golfers = queryExecute('select first_name, last_name, nickname, email_address, id from golfer order by last_name, first_name ' );
        for( var golfer in golfers ){
            ret.append( {'id': golfer.id, 'firstName': golfer.first_name, 'lastName': golfer.last_name, 'nickname': golfer.nickname, 'email': golfer.email_address, 'fullname': golfer.first_name & ' ' & golfer.last_name } );
        }
        return ret;
    }
}