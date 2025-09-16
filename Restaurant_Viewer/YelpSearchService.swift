import Foundation

class YelpSearchService {
    
    private let apiKey = "cVIFnGVzfHFFWtvZUhDKkB29nVnRQlt5EwocZ_yhlqgcakSwMqOB98L_SkMPP7ZCo-7frPh-wLoc0uE8yCMA5sHP4Fq8_kHTHhJLA-5-B39ZWzKsB7uGCzOheV6_aHYx"
    
    func searchBusinesses(
        latitude: Double,
        longitude: Double,
        categories: String = "Restaurants",
        sortBy: String = "distance",
        limit: Int = 20,
        offset: Int
    ) async throws -> [Restaurant] {
        
        let url = URL(string: "https://api.yelp.com/v3/businesses/search")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            //          URLQueryItem(name: "location", value: location),
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "categories", value: categories),
            URLQueryItem(name: "sort_by", value: sortBy),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "authorization": "Bearer \(apiKey)"
        ]
        
        let (data, _) = try await URLSession.shared.data(for: request)
        print(String(decoding: data, as: UTF8.self))
        
        let yelpSearchResponse = try JSONDecoder().decode(YelpSearchResponse.self, from: data)
        
        return yelpSearchResponse.businesses
    }
}

extension YelpSearchService {
    struct YelpSearchResponse: Codable {
        var businesses: [Restaurant]
        
    }
}

