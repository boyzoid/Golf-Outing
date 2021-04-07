package golf.outing.model

import com.fasterxml.jackson.annotation.JsonIgnore
import groovy.transform.CompileStatic

import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Table

@Entity
@CompileStatic
@Table(name='hole')
class Hole {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id
    Integer number
    Integer par
    Integer handicap

    @JsonIgnore
    @ManyToOne
    @JoinColumn( name="course_id" )
    Course course
}
