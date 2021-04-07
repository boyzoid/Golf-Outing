package golf.outing.controller

import io.micronaut.http.HttpResponse
import io.micronaut.http.annotation.Controller
import io.micronaut.http.annotation.Get
import io.micronaut.http.annotation.Post

@Controller("/login")
class LoginController extends BaseController{

    @Post(uri="/")
    HttpResponse index() {
        HttpResponse.ok( [ success: true, token: 'ABCD' ] );
    }
}