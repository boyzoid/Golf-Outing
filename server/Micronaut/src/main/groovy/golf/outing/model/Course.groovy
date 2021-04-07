package golf.outing.model

import com.fasterxml.jackson.annotation.JsonBackReference
import com.sun.istack.NotNull
import groovy.transform.CompileStatic
import io.micronaut.data.annotation.Transient
import org.hibernate.annotations.Fetch
import org.hibernate.annotations.FetchMode

import javax.persistence.CascadeType
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.OneToMany
import javax.persistence.OrderBy
import javax.persistence.Table
import javax.validation.constraints.Max
import javax.validation.constraints.Min
import javax.validation.constraints.NotEmpty
import javax.validation.constraints.Positive
import javax.validation.constraints.Size

@Entity
@CompileStatic
@Table( name='course')
class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id
    @NotEmpty
    @Size( max=50, message='Name must 50 characters or fewer.' )
    String name
    @NotEmpty
    @Size( max=45, message='City must 45 characters or fewer.' )
    String city
    @NotEmpty
    @Size( min=2, max=2, message='State must be 2 characters.' )
    String state
    @NotEmpty
    @Min( value=55L, message='Course Slope must be equal to or higher than 55.' )
    @Max( value=155L, message='Course Slope must be equal to or lower than 155' )
    Integer slope
    @NotEmpty
    @Positive
    Float rating

    @OneToMany( mappedBy = 'course', cascade=CascadeType.ALL, fetch= FetchType.EAGER )
    @OrderBy( 'number asc' )
    @Fetch(value = FetchMode.SUBSELECT)
    List<Hole> holes
}
