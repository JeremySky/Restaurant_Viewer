import SwiftUI

struct UserInterfaceIdiomKey: EnvironmentKey {
    static let defaultValue: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom
}

extension EnvironmentValues {
    var userInterfaceIdiom: UIUserInterfaceIdiom {
        get { self[UserInterfaceIdiomKey.self] }
    }
}
