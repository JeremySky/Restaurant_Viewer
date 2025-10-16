import Foundation



struct Restaurant: Codable, Identifiable, Equatable {
    let id: String
    var name: String?
    var rating: Double?
    var imageURL: String?
    var distance: Double?
    
    //MARK: User-Specific Data
    var isFavorite: Bool?
    
    //MARK: UI-Specific Data for LazyCardStack
    var animationPhase: CardAnimationPhase?
    
    //MARK: - Computed Properties
    var formattedRating: String {
        String(format: "%.1f", self.rating ?? 0)
    }
    
    var formattedDistance: String {
        guard let distance else { return "0.0" }
        
        let miles = distance / 1609
        return String(format: "%.1f", miles)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case rating = "rating"
        case imageURL = "image_url"
        case distance = "distance"
    }
}

#if DEBUG
extension Restaurant {
    enum MockScenario {
        case loaded, loading, empty
    }
    
    static func mock(_ scenario: MockScenario) -> Restaurant {
        var imageURL: String? {
            switch scenario {
            case .loaded:
                "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400"
            case .loading:
                "loading"
            case .empty:
                nil
            }
        }
        
        return Restaurant(
            id: "mock",
            name: "Mock",
            rating: 5.0,
            imageURL: imageURL
        )
    }
    
    static let mockRestaurants: [Restaurant] = [
        Restaurant(
            id: "1",
            name: "The Golden Spoon",
            rating: 4.8,
            imageURL: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400",
            animationPhase: .current
        ),
        Restaurant(
            id: "2",
            name: "Pasta Paradise",
            rating: 4.5,
            imageURL: nil,
            animationPhase: .current
        ),
        Restaurant(
            id: "3",
            name: "Sakura Sushi",
            rating: 4.9,
            imageURL: "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400",
            animationPhase: .current
        ),
        Restaurant(
            id: "4",
            name: "BBQ Pit Stop",
            rating: 4.3,
            imageURL: "https://images.unsplash.com/photo-1544025162-d76694265947?w=400",
        ),
        Restaurant(
            id: "5",
            name: "Mediterranean Breeze",
            rating: 4.6,
            imageURL: "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400"
        ),
        Restaurant(
            id: "6",
            name: "Taco Libre",
            rating: 4.2,
            imageURL: "https://images.unsplash.com/photo-1565299507177-b0ac66763f30?w=400"
        ),
        Restaurant(
            id: "7",
            name: "The Coffee House",
            rating: 4.4,
            imageURL: "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400"
        ),
        Restaurant(
            id: "8",
            name: "Dragon Palace",
            rating: 4.7,
            imageURL: "https://images.unsplash.com/photo-1526318896980-cf78c088247c?w=400"
        ),
        Restaurant(
            id: "9",
            name: "Farm to Table Bistro",
            rating: 4.5,
            imageURL: "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400"
        ),
        Restaurant(
            id: "10",
            name: "Spice Route",
            rating: 4.1,
            imageURL: "https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400"
        )
    ]
}
#endif
