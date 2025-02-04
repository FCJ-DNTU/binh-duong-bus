package fcj.dntu.vn.backend.exceptions.handlers;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import fcj.dntu.vn.backend.exceptions.ErrorResponse;
import fcj.dntu.vn.backend.exceptions.RouteNotFound;
import jakarta.servlet.http.HttpServletRequest;

/**
 * GlobalExceptionHandler handles exceptions globally for the application.
 * It provides a centralized way to manage error responses.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {
    private final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * Handles not found exceptions and returns a standardized error response.
     * 
     * @param e   the thrown exception
     * @param req the current web request
     * @return an ErrorResponse contains Http Status, message, and current path.
     */
    @ExceptionHandler({ RouteNotFound.class })
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorResponse handleNotFound(Exception e, HttpServletRequest req) {
        return new ErrorResponse(
                HttpStatus.NOT_FOUND,
                e.getMessage(),
                req.getRequestURL().toString());
    }

    // bad request exceptions

    /**
     * Handles unknown exceptions and returns a standardized error response.
     * Logs the error message for debugging purposes.
     * 
     * @param e   the thrown exception
     * @param req the current web request
     * @return an ErrorResponse contains Http Status, message, and current path.
     */
    @ExceptionHandler(Exception.class)
    public ErrorResponse handleUnknownException(Exception e, HttpServletRequest req) {
        logger.error("Exception caught: ", e);
        return new ErrorResponse(
                HttpStatus.INTERNAL_SERVER_ERROR,
                e.getMessage(),
                req.getRequestURL().toString());
    }
}
