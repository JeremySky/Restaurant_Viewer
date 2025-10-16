import Foundation

enum RestaurantCategory: String, CaseIterable, Identifiable, Equatable {
    case pizza, burger, ramen, sushi, vegetarian, breakfast, mexican, chinese, steakhouse, seafood, bar, salad
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .pizza:
            "🍕"
        case .burger:
            "🍔"
        case .ramen:
            "🍜"
        case .sushi:
            "🍣"
        case .mexican:
            "🌮"
        case .chinese:
            "🥡"
        case .steakhouse:
            "🥩"
        case .seafood:
            "🐟"
        case .vegetarian:
            "🫜"
        case .breakfast:
            "🥞"
        case .bar:
            "🍻"
        case .salad:
            "🥗"
        }
    }
}
