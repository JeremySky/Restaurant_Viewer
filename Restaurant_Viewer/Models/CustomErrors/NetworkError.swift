import Foundation

enum NetworkError: Error {
    case httpStatusError(Int)
    
    var customErrorMessage: String {
        switch self {
        case .httpStatusError(let code):
            return "Request failed with status code: \(code)"
        }
    }
}
