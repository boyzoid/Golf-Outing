package golf.outing.model

import com.fasterxml.jackson.annotation.JsonIgnore
import groovy.transform.CompileStatic
import org.hibernate.annotations.Fetch
import org.hibernate.annotations.FetchMode

import javax.persistence.CascadeType
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToMany
import javax.persistence.ManyToOne
import javax.persistence.OneToMany
import javax.persistence.OneToOne
import javax.persistence.Table
import javax.validation.constraints.Positive

@Entity
@CompileStatic
@Table( name='outing_golfer')
class OutingGolfer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id
    @Positive
    Float handicapIndex = 0

    @JsonIgnore
    @ManyToOne
    @JoinColumn( name="outing_id" )
    Outing outing

    @OneToOne
    @JoinColumn( name="golfer_id" )
    Golfer golfer
}
