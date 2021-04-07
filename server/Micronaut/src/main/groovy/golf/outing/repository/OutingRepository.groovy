package golf.outing.repository

import golf.outing.model.Golfer
import golf.outing.model.Outing
import groovy.transform.CompileStatic
import io.micronaut.data.annotation.Join
import io.micronaut.data.annotation.Query
import io.micronaut.data.annotation.Repository
import io.micronaut.data.repository.CrudRepository
import io.micronaut.http.HttpResponse
import io.micronaut.http.annotation.Body
import io.micronaut.http.annotation.Post
import io.micronaut.http.annotation.Put
import org.hibernate.Session
import org.hibernate.transform.AliasToEntityMapResultTransformer


import javax.persistence.EntityManager
import javax.transaction.Transactional
import javax.validation.Valid


@CompileStatic
@Repository
abstract class OutingRepository implements CrudRepository< Outing, Long> {
    private final EntityManager entityManager

    OutingRepository( EntityManager entityManager ){
        this.entityManager = entityManager
    }

    Session getSession() {
        Session session = entityManager.unwrap(Session.class)
        return session
    }

    @Transactional
    List list() {
        return getSession().createSQLQuery("""select o.scored as scored, o.id as id, DATE_FORMAT(o.date, '%c/%d/%Y') as date, o.tee_time as teeTime, c.name as name, c.city as city,c.state as state, u.first_name as firstName, u.last_name as lastName, u.email_address as email
        from outing o
        join course c on o.course_id = c.id
        join golfer u on o.managed_by = u.id
        order by o.scored desc, o.date desc, o.tee_time""")
                .setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                .list()
    }

    @Transactional
    List listOutingGolfers( Long id) {
        return getSession().createSQLQuery("""select  og.id id, g.first_name firstName, g.last_name lastName, og.handicap_index handicapIndex
                    from outing_golfer og
                    join golfer g on og.golfer_id = g.id
                    where og.outing_id = :id
                    order by g.last_name, g.first_name""")
                .setParameter( 'id', id )
                .setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                .list()
    }

    @Transactional
    List listAvailableGolfers( Long id ){
        return getSession().createSQLQuery("""select first_name firstName, last_name lastName, nickname, email_address email, id
            from golfer
            where
            active = 1
            and id not in( select golfer_id from outing_golfer where outing_id = :id)
            order by last_name, first_name""")
                .setParameter( 'id', id )
                .setResultTransformer(AliasToEntityMapResultTransformer.INSTANCE)
                .list()
    }

    abstract Outing getById(Long id );

    @Transactional
    addGolferToOuting( Long outingId, Long golferId ){
        return getSession().createNativeQuery("""
            insert into outing_golfer ( outing_id, golfer_id, handicap_index ) 
            select * from (select :outingId as outing_id, :golferId as golfer_id, 0 as handicap_index) as tmp 
            where not exists ( 
                select id from outing_golfer where golfer_id = :golferId and outing_id = :outingId 
            ) limit 1
        """)
                .setParameter( 'outingId', outingId)
                .setParameter( 'golferId', golferId )
                .executeUpdate()
    };

    @Transactional
    deleteGolferFromOuting( Long outingId, Long golferId ){
        return getSession().createNativeQuery("""
            delete from outing_golfer where golfer_id = :golferId and outing_id = :outingId 
        """)
                .setParameter( 'outingId', outingId)
                .setParameter( 'golferId', golferId )
                .executeUpdate()
    }

}
