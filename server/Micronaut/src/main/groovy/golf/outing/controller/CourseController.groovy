package golf.outing.controller

import golf.outing.model.Course
import golf.outing.model.Golfer
import golf.outing.repository.CourseRepository
import groovy.transform.CompileStatic
import io.micronaut.http.HttpRequest
import io.micronaut.http.HttpResponse
import io.micronaut.http.annotation.Body
import io.micronaut.http.annotation.Controller
import io.micronaut.http.annotation.Error
import io.micronaut.http.annotation.Get
import io.micronaut.http.annotation.Post
import io.micronaut.http.annotation.Put

import javax.validation.ConstraintViolation
import javax.validation.ConstraintViolationException
import javax.validation.Valid

@CompileStatic
@Controller("/course")
class CourseController extends BaseController{

    private final CourseRepository courseRepository

    CourseController( CourseRepository courseRepository ){
        this.courseRepository = courseRepository
    }

    @Get(uri='/list')
    HttpResponse list(){
        return HttpResponse.ok(
            [ success: true, courses: courseRepository. listOrderByName() ]
        )
    }

    @Get(uri="/{id}")
    HttpResponse index( Long id){
        Course course = new Course();
        if( id > 0 ){
            course = courseRepository.getById( id )
        }

        return HttpResponse.ok(
            [ success: true, course: course ]
        )
    }

    @Put( uri="/")
    HttpResponse putCourse(@Body @Valid Course course){
        for( def hole in course.holes ){
            hole.course = course
        }
        courseRepository.update( course);
        return HttpResponse.ok(
            [ success: true, course: courseRepository.getById( course.id ) ]
        )
    }

    @Post( uri="/")
    HttpResponse saveCourse(@Body @Valid Course course){
        for( def hole in course.holes ){
            hole.course = course
        }
        courseRepository.save( course )
        return HttpResponse.ok(
            [ success: true, course: courseRepository.getById( course.id ) ]
        )
    }
}