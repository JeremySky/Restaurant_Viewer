import Foundation

protocol RestaurantSearchProtocol {
    func fetchRestaurants(at coordinate: Coordinate, sortBy: SortCriteria?, for category: RestaurantCategory?, offsetBy offset: Int) async throws -> [Restaurant]
}

final class YelpSearchServices: RestaurantSearchProtocol {
    
    private let apiKey = "API_KEY_HERE"
    
    func fetchRestaurants(at coordinate: Coordinate, sortBy: SortCriteria?, for category: RestaurantCategory?, offsetBy offset: Int) async throws -> [Restaurant] {
        
        let limit: Int = 20
        
        let url = URL(string: "https://api.yelp.com/v3/businesses/search")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "latitude", value: String(coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(coordinate.longitude)),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        if let sortCriteria = sortBy {
            queryItems.append(URLQueryItem(name: "sort_by", value: sortCriteria.rawValue))
        }
        if let category {
            queryItems.append(URLQueryItem(name: "categories", value: category.rawValue))
        }
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "authorization": "Bearer \(apiKey)"
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
        guard let httpResponse = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        guard (200...299).contains(httpResponse.statusCode) else { throw NetworkError.httpStatusError(httpResponse.statusCode) }
        
        let yelpSearchResponse = try JSONDecoder().decode(YelpSearchResponse.self, from: data)
        
        guard let restaurants = yelpSearchResponse.businesses else { throw YelpError(yelpSearchResponse.error) }
        
        return restaurants
    }
}

extension YelpSearchServices {
    struct YelpSearchResponse: Codable {
        var businesses: [Restaurant]?
        var error: YelpSearchServiceError?
    }
}

public struct YelpSearchServiceError: Codable {
    var code: String
    var description: String?
}


#if DEBUG
final class MockRestaurantSearchService: RestaurantSearchProtocol {
    enum Senario {
        case preloaded
        case success
        case failure(Error)
        case timeout
        case empty
    }
    
    private let scenario: Senario
    
    init(scenario: Senario) {
        self.scenario = scenario
    }
    
    func fetchRestaurants(at coordinate: Coordinate, sortBy: SortCriteria?, for category: RestaurantCategory?, offsetBy offset: Int) async throws -> [Restaurant] {
        switch scenario {
        case .preloaded:
            return Restaurant.mockRestaurants
            
        case .success:
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return Restaurant.mockRestaurants
            
        case .failure(let error):
            throw error
            
        case .timeout:
            try await Task.sleep(nanoseconds: 10_000_000_000)
            throw URLError(.timedOut)
            
        case .empty:
            return []
        }
    }
}
#endif
