component accessors=true{

    public function listGolfers(){
        var ret = [];
        var golfers = queryExecute('select first_name, last_name, nickname, email_address, id from golfer where active = 1 order by last_name, first_name ' );
        for( var golfer in golfers ){
            ret.append( {'id': golfer.id, 'firstName': golfer.first_name, 'lastName': golfer.last_name, 'nickname': golfer.nickname, 'email': golfer.email_address, 'fullname': golfer.first_name & ' ' & golfer.last_name } );
        }
        return ret;
    }

    public function listGolfersForOuting( numeric id=0 ){
        var ret = [];
        var golfers = queryExecute('select first_name, last_name, nickname, email_address, id
            from golfer
            where
            active = 1
            and id not in( select golfer_id from outing_golfer where outing_id = :id)
            order by last_name, first_name ', { id: id } );
        for( var golfer in golfers ){
            ret.append( {'id': golfer.id, 'firstName': golfer.first_name, 'lastName': golfer.last_name, 'nickname': golfer.nickname, 'email': golfer.email_address, 'fullname': golfer.first_name & ' ' & golfer.last_name } );
        }
        return ret;
    }

    public function putGolfer( struct golfer ){
        if( val(golfer.id) == 0 ){
            addGolfer( golfer );
        }
        else{
            updateGolfer( golfer );
        }
        return {'success': true};
    }

    private function addGolfer( struct golfer ){
        queryExecute('insert into golfer( first_name, last_name, nickname, email_address) values(:firstName, :lastName, :nickname, :email )',
         {
            firstName: golfer.firstName,
            lastName: golfer.lastName,
            nickname: golfer.nickname,
            email: golfer.email
         });
    }

    private function updateGolfer( struct golfer ){
        queryExecute('update golfer set first_name = :firstName, last_name = :lastName, nickname = :nickname, email_address = :email where id = :id',
        {
            firstName: golfer.firstName,
            lastName: golfer.lastName,
            nickname: golfer.nickname,
            email: golfer.email,
            id: golfer.id
        }
        )
    }
}