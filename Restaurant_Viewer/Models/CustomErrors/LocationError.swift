import Foundation

enum LocationError: Error {
    case permissionDenied
    case timeout
    case unknown
    case noNearbyRestaurants
    case locationUnknown
    
    var customErrorMessage: String {
        switch self {
        case .permissionDenied:
            return "Allow location services for app in settings and try again."
        case .timeout:
            return "Retrieving location took taking too long. Please try again later."
        case .unknown:
            return "Unknown error while getting location. Please try again later."
        case .noNearbyRestaurants:
            return "No nearby restaurants found. Please try again later."
        case .locationUnknown:
            return "Unable to retrieve location. Please try again later."
        }
    }
}
