package golf.outing.controller

import io.micronaut.http.HttpRequest
import io.micronaut.http.annotation.Error

import javax.validation.ConstraintViolation
import javax.validation.ConstraintViolationException

class BaseController {
    @Error(exception = ConstraintViolationException.class)
    Map<String, Object> onValidationException(HttpRequest request, ConstraintViolationException ex) {
        return [
                errors: ex.constraintViolations.collect { ConstraintViolation it ->
                    [
                            message: it.message,
                            property: it.propertyPath.last().name,
                    ]
                },
                body: request?.getBody(),
        ]
    }
}
