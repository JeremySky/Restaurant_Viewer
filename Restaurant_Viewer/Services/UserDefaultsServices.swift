import Foundation

final class UserDefaultsServices {
    static let shared = UserDefaultsServices()
    private let defaults = UserDefaults.standard

    private init() {}

    func setIsFavorite(_ value: Bool, forKey key: String) {
        if value == true {
            defaults.set(value, forKey: key)
        } else {
            defaults.removeObject(forKey: key)
        }
    }

    func getIsFavorite(forKey key: String) -> Bool {
        defaults.bool(forKey: key)
    }
}
