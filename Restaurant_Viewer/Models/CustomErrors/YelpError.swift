import Foundation

enum YelpError: Error {
    case invalidRequest, unauthorized, invalidToken, authorizationError, resourceNotFound, payloadTooLarge, rateLimited, internalServerError, serviceUnavailable, unknown(String), validation
    
    init(_ error: YelpSearchServiceError?) {
        guard let errorCode = error?.code else {
            self = .unknown("Unknown Error")
            return
        }
        
        switch errorCode {
        case "INVALID_REQUEST": self = .invalidRequest
        case "UNAUTHORIZED_API_KEY": self = .unauthorized
        case "TOKEN_INVALID": self = .invalidToken
        case "AUTHORIZATION_ERROR": self = .authorizationError
        case "NOT_FOUND": self = .resourceNotFound
        case "PAYLOAD_TOO_LARGE": self = .payloadTooLarge
        case "TOO_MANY_REQUESTS_PER_SECOND": self = .rateLimited
        case "INTERNAL_ERROR": self = .internalServerError
        case "SERVICE_UNAVAILABLE": self = .serviceUnavailable
        case "VALIDATION_ERROR": self = .validation
        default: self = .unknown(errorCode)
        }
//        switch errorCode {
//        case 400: self = .invalidRequest
//        case 401: self = .unauthorized
//        case 403: self = .authorizationError
//        case 404: self = .resourceNotFound
//        case 413: self = .payloadTooLarge
//        case 429: self = .rateLimited
//        case 500: self = .internalServerError
//            case 503: self = .serviceUnavailable
//        default: self = .unknown(errorCode.description)
//        }
    }
    
    var customErrorMessage: String {
        switch self {
        case .invalidRequest:
            return "Request was invalid"
        case .unauthorized, .invalidToken, .authorizationError, .validation:
            return "Unable to fulfill request, check authorization and try again."
        case .resourceNotFound:
            return "Resource not found"
        case .payloadTooLarge:
            return "Request was too large, try smaller radius."
        case .rateLimited:
            return "Too many frequent requests, try again later."
        case .internalServerError:
            return "Internal Server Error, try again later."
        case .serviceUnavailable:
            return "Service Unavailable, try again later."
        case .unknown(let code):
            return "Unknown Error with code: \(code)"
        }
    }
}
