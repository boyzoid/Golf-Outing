package golf.outing.controller

import golf.outing.model.Golfer
import golf.outing.repository.CourseRepository
import golf.outing.repository.GolferRepository
import io.micronaut.http.HttpResponse
import io.micronaut.http.annotation.Body
import io.micronaut.http.annotation.Controller
import io.micronaut.http.annotation.Get
import io.micronaut.http.annotation.Post
import io.micronaut.http.annotation.Put

import javax.validation.Valid

@Controller("/golfer")
class GolferController extends BaseController {

    private final GolferRepository golferRepository

    GolferController( GolferRepository golferRepository ){
        this.golferRepository = golferRepository
    }

    @Get(uri="/")
    HttpResponse index() {
        return HttpResponse.ok(
            [ success: true, golfers: golferRepository.list() ]
        )
    }

    @Put( uri="/")
    HttpResponse putGolfer(@Body @Valid Golfer golfer){
        golferRepository.update( golfer );
         return HttpResponse.ok(
             [ success: true, golfer: golfer ]
        )
    }

    @Post( uri="/")
    HttpResponse saveGolfer(@Body @Valid Golfer golfer){
        golferRepository.save( golfer )
        return HttpResponse.ok(
            [ success: true, golfer: golfer ]
        )
    }
}