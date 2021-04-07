package golf.outing.repository

import golf.outing.model.Golfer
import groovy.transform.CompileStatic
import io.micronaut.data.annotation.Query
import io.micronaut.data.annotation.Repository
import io.micronaut.data.repository.CrudRepository

import javax.persistence.EntityManager

@CompileStatic
@Repository
abstract class GolferRepository implements CrudRepository< Golfer, Long> {
    private final EntityManager entityManager

    GolferRepository( EntityManager entityManager ){
        this.entityManager = entityManager
    }
    @Query("select g From Golfer g where g.active = 1 order by g.lastName, g.firstName")
    abstract List<Golfer> list()

    abstract Golfer getById( Long id );
}
