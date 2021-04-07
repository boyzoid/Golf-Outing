package golf.outing.repository

import golf.outing.model.Course
import groovy.transform.CompileStatic
import io.micronaut.data.annotation.Join
import io.micronaut.data.annotation.Query
import io.micronaut.data.annotation.Repository
import io.micronaut.data.repository.CrudRepository

import javax.persistence.EntityManager
import javax.transaction.Transactional

@CompileStatic
@Repository
abstract class CourseRepository implements CrudRepository< Course, Long>{
    private final EntityManager entityManager

    CourseRepository( EntityManager entityManager ){
        this.entityManager = entityManager
    }
    @Query("select distinct c from Course c left join fetch c.holes ch order by c.name, ch.number")
    abstract List<Course> listOrderByName()

    @Query("select c from Course c left join fetch c.holes ch where c.id = :id order by ch.number")
    abstract Course getById( Long id );
}
