package golf.outing.model

import com.fasterxml.jackson.annotation.JsonFormat
import com.fasterxml.jackson.annotation.JsonIgnore
import groovy.transform.CompileStatic
import org.hibernate.annotations.FetchMode
import org.hibernate.annotations.Fetch

import javax.persistence.CascadeType
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.OneToMany
import javax.persistence.Table
import javax.persistence.Transient
import javax.validation.constraints.NotEmpty
import java.sql.Date
import java.sql.Time
import groovy.json.JsonSlurper

@Entity
@CompileStatic
@Table( name='outing' )
class Outing {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id
    @NotEmpty
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX")
    Date date
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "HH:mm:ss")
    Time teeTime
    Boolean scored = false
    @JsonIgnore
    @Column( name='teams' )
    String teamsJson = '[]'

    @ManyToOne
    @JoinColumn( name="course_id" )
    Course course

    @ManyToOne
    @JoinColumn( name="managed_by" )
    Golfer organizer

    @OneToMany( mappedBy = 'outing', cascade= CascadeType.ALL, fetch= FetchType.EAGER )
    @Fetch(value = FetchMode.SUBSELECT)
    List<OutingGolfer> outingGolfers

    @Transient
    List teams=[]

    List<OutingGolfer> getOutingGolfers(){
       this.outingGolfers.sort { a, b ->
            a.golfer.lastName <=> b.golfer.lastName ?: a.golfer.firstName <=> b.golfer.firstName
        }
    }

    def getTeams(){
        def jsonSlurper = new groovy.json.JsonSlurper()
        List<Map> teams = jsonSlurper.parseText( this.teamsJson ) as List<Map>
        teams.sort { a, b ->
            Map<String, Integer> aTots = a.totals as Map
            Map<String, Integer> bTots = b.totals as Map
            aTots.total <=> bTots.total
        }

    }

}
