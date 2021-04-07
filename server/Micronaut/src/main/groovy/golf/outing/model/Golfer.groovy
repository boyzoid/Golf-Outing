package golf.outing.model

import com.fasterxml.jackson.annotation.JsonIgnore
import com.sun.istack.NotNull
import groovy.transform.CompileStatic
import groovy.transform.MapConstructor

import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.Table
import javax.validation.constraints.Email
import javax.validation.constraints.Size

@Entity
@CompileStatic
@Table( name='golfer')
@MapConstructor(noArg = true)
class Golfer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id
    @NotNull
    @Size( max=45, message='First Name must 45 characters or fewer.' )
    String firstName
    @NotNull
    @Size( max=45, message='Last Name must 45 characters or fewe.' )
    String lastName
    @NotNull
    @Size( max=45, message='Nickname must 45 characters or fewe.' )
    String nickname
    @NotNull
    @Email( message="Email must be a valid email address.")
    String emailAddress
    @JsonIgnore
    @NotNull
    String password
    Boolean isAdmin = false
    Boolean active = true
}
