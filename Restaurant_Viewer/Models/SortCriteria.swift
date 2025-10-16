import Foundation

enum SortCriteria: String, CaseIterable, Identifiable {
    case distance, rating
    
    var rawValue: String {
        switch self {
        case .distance:
            "distance"
        case .rating:
            "rating"
        }
    }
    
    var id: String { self.rawValue }
}
