import Foundation

@MainActor
final class ViewModel: ObservableObject {
    private enum FetchAction { case replace, append }
    
    // MARK: - Published State
    @Published var coordinate: Coordinate? = nil
    @Published var sortCriteria: SortCriteria? = nil
    @Published var restaurantCategory: RestaurantCategory? = nil

    @Published var restaurants: [Restaurant] = []
    @Published var currentRestaurantIndex: Int = 0

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var filterIsPresenting: Bool = false

    // MARK: - Dependencies / Services
    private let locationService: LocationServiceProtocol
    private let searchService: RestaurantSearchProtocol

    // MARK: - Internal State / Throttling
    private var lastActionTime: Date = .distantPast
    private let cooldown: TimeInterval = 0.3
    
    init(
        locationService: LocationServiceProtocol = LocationServices(),
        searchService: RestaurantSearchProtocol = YelpSearchServices()
    ) {
        self.locationService = locationService
        self.searchService = searchService
    }
    
    // MARK: - Functions
    
    func fetchRestaurants() {
        handleFetchRestaurant(action: .replace)
    }
    
    func fetchRestaurants(sortCriteria: SortCriteria?, restaurantCategory: RestaurantCategory?) {
        guard self.sortCriteria != sortCriteria || self.restaurantCategory != restaurantCategory else { return }
        self.sortCriteria = sortCriteria
        self.restaurantCategory = restaurantCategory
        handleFetchRestaurant(action: .replace)
    }
    
    func prevRestaurant() {
        guard currentRestaurantIndex > 0 else { return }
        
        let now = Date()
        guard now.timeIntervalSince(lastActionTime) > cooldown else { return }
        self.lastActionTime = now
        
        self.currentRestaurantIndex -= 1
    }
    
    func nextRestaurant() {
        guard currentRestaurantIndex < restaurants.count - 1 else { return }
        let now = Date()
        guard now.timeIntervalSince(lastActionTime) > cooldown else { return }
        self.lastActionTime = now
        
        self.currentRestaurantIndex += 1
        
        if currentRestaurantIndex == restaurants.count - 10 && !isLoading {
            handleFetchRestaurant(action: .append)
        }
    }
    
    // MARK: - Helper Functions
    private func fetchLocation() async throws {
        self.coordinate = try await locationService.fetchLocation()
    }
    
    private func handleFetchRestaurant(action: FetchAction) {
        self.isLoading = true
        
        Task {
            do {
                if coordinate == nil { try await fetchLocation() }
                guard let coordinate else { throw LocationError.locationUnknown }
                
                
                switch action {
                    
                case .replace:
                    self.restaurants = []
                    
                    let fetchedRestaurants = try await searchService.fetchRestaurants(
                        at: coordinate,
                        sortBy: sortCriteria,
                        for: restaurantCategory,
                        offsetBy: 0
                    )
                    
                    var positionedRestaurants: [Restaurant] = fetchedRestaurants
                    let cardAnimationPhases: [CardAnimationPhase] = [.current, .next, .last]
                    for i in 0..<min(cardAnimationPhases.count, fetchedRestaurants.count) {
                        positionedRestaurants[i].animationPhase = cardAnimationPhases[i]
                    }
                    
                    self.currentRestaurantIndex = 0
                    self.restaurants = positionedRestaurants
                    
                case .append:
                    let fetchedRestaurants = try await searchService.fetchRestaurants(
                        at: coordinate,
                        sortBy: sortCriteria,
                        for: restaurantCategory,
                        offsetBy: restaurants.count
                    )
                    self.restaurants.append(contentsOf: fetchedRestaurants)
                }
                
                if restaurants.isEmpty { throw LocationError.noNearbyRestaurants }
                
            //MARK: Handle Errors
            } catch let error as LocationError {
                self.errorMessage = error.customErrorMessage
                
            } catch let error as YelpError {
                self.errorMessage = error.customErrorMessage
                
            } catch let error as NetworkError {
                print(error.customErrorMessage)
                self.errorMessage = "Please check your internet connection and try again. - NetworkError"
                
            } catch let error as URLError {
                print(error)
                self.errorMessage = "Please check your internet connection and try again. - URLError"
                
            } catch let error as DecodingError {
                print(error)
                self.errorMessage = "Something went wrong while processing the data. Please try again later."
                
            } catch {
                print(error)
                self.errorMessage = "An unexpected error occurred. Please try again later."
                
            }

            self.isLoading = false
        }
    }
}
