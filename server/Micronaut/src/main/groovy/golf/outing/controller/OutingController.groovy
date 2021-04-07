package golf.outing.controller

import golf.outing.model.Outing
import golf.outing.repository.CourseRepository
import golf.outing.repository.GolferRepository
import golf.outing.repository.OutingRepository
import golf.outing.repository.OutingRepository
import io.micronaut.http.HttpResponse
import io.micronaut.http.annotation.Body
import io.micronaut.http.annotation.Controller
import io.micronaut.http.annotation.Get
import io.micronaut.http.annotation.Post
import io.micronaut.http.annotation.Put

import javax.validation.Valid

@Controller("/outing")
class OutingController extends BaseController{
    private final OutingRepository outingRepository
    private final GolferRepository golferRepository
    private final CourseRepository courseRepository

    OutingController( OutingRepository outingRepository, GolferRepository golferRepository, CourseRepository courseRepository ){
        this.outingRepository = outingRepository
        this.golferRepository = golferRepository
        this.courseRepository = courseRepository
    }

    @Get(uri='/list')
    HttpResponse list(){
        return HttpResponse.ok(
                [ success: true, outings: outingRepository.list() ]
        )
    }
    
    @Get(uri="/{id}")
    HttpResponse index( Long id){
        Outing outing = new Outing();
        if( id > 0 ){
            outing = outingRepository.getById( id )

        }

        return HttpResponse.ok(
            [
            success: true,
            outing: outing,
            allGolfers:  outingRepository.listAvailableGolfers( id )
            ]
        )
    }
    @Put( uri="/")
    HttpResponse putOuting(@Body @Valid Outing outing){
        outingRepository.update( outing );
        return HttpResponse.ok(
                [ success: true, outing: outing ]
        )
    }

    @Post( uri="/")
    HttpResponse saveOuting(@Body @Valid Outing outing){
        outingRepository.save( outing )
        return HttpResponse.ok(
                [ success: true, outing: outing ]
        )
    }

    @Post( uri="/addGolfers")
    HttpResponse addGolfers( golfers, Long outingId ){
        for( golferId in golfers ){
            outingRepository.addGolferToOuting( outingId as Long, golferId.asLong() )
        }
        return HttpResponse.ok(
                [ success: true, outing: outingRepository.getById( outingId ), golfers:  outingRepository.listAvailableGolfers( outingId ) ]
        )
    }

    @Get( uri='/deleteGolfer/{outingId}/{golferId}' )
    HttpResponse deleteGolfer( Long outingId, Long golferId ){
        outingRepository.deleteGolferFromOuting( outingId, golferId )
        return HttpResponse.ok(
                [ success: true, outing: outingRepository.getById( outingId ), golfers:  outingRepository.listAvailableGolfers( outingId ) ]
        )
    }
}