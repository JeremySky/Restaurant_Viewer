import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    func fetchLocation() async throws -> Coordinate
}

final class LocationServices: NSObject, ObservableObject, LocationServiceProtocol {
    
    private let manager = CLLocationManager()
    
    @Published var coordinate: Coordinate?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.distanceFilter = 50
    }
    
    func fetchLocation() async throws -> Coordinate {
        guard manager.authorizationStatus != .denied else { throw LocationError.permissionDenied }
        
        let fetchTask = Task {
            while self.coordinate == nil {
                try await Task.sleep(nanoseconds: 300_000_000)
                print("loading...")
                try Task.checkCancellation()
            }
            guard let coordinate else { throw LocationError.unknown }
            return coordinate
        }
        
        let timeoutTask = Task {
            try await Task.sleep(nanoseconds: UInt64(5) * NSEC_PER_SEC)
            fetchTask.cancel()
        }
        
        do {
            let result = try await fetchTask.value
            timeoutTask.cancel()
            return result
            
        } catch is CancellationError {
            throw LocationError.timeout
            
        } catch {
            throw LocationError.unknown
            
        }
    }
}

extension LocationServices: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard location.timestamp.timeIntervalSinceNow > -60.0 else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        self.coordinate = Coordinate(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // WIP - ERROR MESSAGE
            print("LocationHandler: Location access denied")
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            manager.requestLocation()
        @unknown default:
            print("LocationHandler: Unknown authorization status")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
}


#if DEBUG
final class MockLocationService: LocationServiceProtocol {
    enum Scenario {
        case preloaded
        case success
        case failure(Error)
        case timeout
    }
    
    private let scenario: Scenario
    
    init(scenario: Scenario) {
        self.scenario = scenario
    }
    
    func fetchLocation() async throws -> Coordinate {
        switch scenario {
        case .preloaded:
            return Coordinate(latitude: 37.7749, longitude: -122.4194) // San Francisco
            
        case .success:
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return Coordinate(latitude: 37.7749, longitude: -122.4194) // San Francisco
            
        case .failure(let error):
            throw error
            
        case .timeout:
            try await Task.sleep(nanoseconds: 5_000_000_000)
            throw LocationError.timeout
            
        }
    }
}
#endif
