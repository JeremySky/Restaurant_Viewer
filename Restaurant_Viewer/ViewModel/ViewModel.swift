import Foundation
import Combine

@MainActor
class ViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var currentRestaurantIndex: Int = 0
    
    @Published var coordinate: (latitude: Double, longitude: Double)?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published  var isFavorite: Bool = false
    
    init(
        restaurants: [Restaurant] = [],
        currentRestaurantIndex: Int = 0,
        coordinate: (latitude: Double, longitude: Double)? = nil,
        isLoading: Bool = false,
        errorMessage: String? = nil,
        isFavorite: Bool = false
    ) {
        self.restaurants = restaurants
        self.currentRestaurantIndex = currentRestaurantIndex
        self.coordinate = coordinate
        self.isLoading = isLoading
        self.errorMessage = errorMessage
        self.isFavorite = isFavorite
    }
    
    func toggleFavorite() -> Bool {
        isFavorite.toggle()
        return isFavorite
    }
    
    private let locationManager = LocationsHandler()
    private let yelpService = YelpSearchService()
    
    var currentRestaurant: Restaurant? {
        guard !restaurants.isEmpty else { return nil }
        return restaurants[currentRestaurantIndex]
    }
    
    var locationNotFound: Bool { coordinate == nil }
    
    func load() {
        self.isLoading = true
        Task {
            await getLocation()
            await fetchRestaurants()
        }
        self.isLoading = false
    }
    
    func getLocation() async {
        guard let coordinate = locationManager.getLocation() else {
            self.errorMessage = "Location not found, try again."
            return
        }
        
        self.coordinate = coordinate
    }
    
    func prevRestaurant() {
        guard currentRestaurantIndex > 0 else { return }
        self.isLoading = true
        self.currentRestaurantIndex -= 1
    }
    
    func nextRestaurant() {
        guard currentRestaurantIndex < restaurants.count - 1 else { return }
        self.isLoading = true
        currentRestaurantIndex += 1
        
        if currentRestaurantIndex == restaurants.count - 6 {
            Task {
                await fetchRestaurants(offset: restaurants.count)
            }
        }
    }
    
    func fetchRestaurants(offset: Int = 0) async {
        guard let latitude = coordinate?.latitude, let longitude = coordinate?.longitude else {
            print("coordinate nil")
            return
        }
        
        do {
            let fetchedRestaurants = try await yelpService.searchBusinesses(latitude: latitude, longitude: longitude, offset: offset)
            self.restaurants.append(contentsOf: fetchedRestaurants)
            
            guard !self.restaurants.isEmpty else {
                self.errorMessage = "No restaurants found"
                return
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}

#if DEBUG
extension ViewModel {
    static var mock: ViewModel {
        ViewModel(
            restaurants: Restaurant.mockRestaurants,
            currentRestaurantIndex: 0,
            coordinate: (32.715736, -117.161087),
            isLoading: false,
            errorMessage: nil,
            isFavorite: false
        )
    }
}
#endif
