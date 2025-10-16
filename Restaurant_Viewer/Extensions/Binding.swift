import SwiftUI

extension Binding where Value == Bool {
    init<T>(_ optionalBinding: Binding<T?>) {
        self.init(
            get: { optionalBinding.wrappedValue != nil },
            set: { if !$0 { optionalBinding.wrappedValue = nil } }
        )
    }
}
