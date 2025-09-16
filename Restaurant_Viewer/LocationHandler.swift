import Foundation
import CoreLocation

class LocationsHandler: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    @Published var coordinate: (latitude: Double, longitude: Double)?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func getLocation() -> (latitude: Double, longitude: Double)? { return coordinate }
}

extension LocationsHandler: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard location.timestamp.timeIntervalSinceNow > -60.0 else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        self.coordinate = (latitude, longitude)
        print(coordinate?.latitude ?? 0)
        print(coordinate?.longitude ?? 0)
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
