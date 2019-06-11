component accessors=true{

    public function listGolfers(){
        var ret = [];
        var golfers = queryExecute('select first_name, last_name, nickname, email_address, id from golfer order by last_name, first_name ' );
        for( var golfer in golfers ){
            ret.append( {'id': golfer.id, 'firstName': golfer.first_name, 'lastName': golfer.last_name, 'nickname': golfer.nickname, 'email': golfer.email_address, 'fullname': golfer.first_name & ' ' & golfer.last_name } );
        }
        return ret;
    }

    public function listGolfersForOuting( numeric id=0 ){
        var ret = [];
        var golfers = queryExecute('select first_name, last_name, nickname, email_address, id
            from golfer
            where id not in( select golfer_id from outing_golfer where outing_id = :id)
            order by last_name, first_name ', { id: id } );
        for( var golfer in golfers ){
            ret.append( {'id': golfer.id, 'firstName': golfer.first_name, 'lastName': golfer.last_name, 'nickname': golfer.nickname, 'email': golfer.email_address, 'fullname': golfer.first_name & ' ' & golfer.last_name } );
        }
        return ret;
    }
}