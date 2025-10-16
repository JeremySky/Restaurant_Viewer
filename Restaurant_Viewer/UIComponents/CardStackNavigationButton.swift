import SwiftUI

struct CardStackNavigationButton: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    let configuration: ButtonStyleConfiguration
    
    var body: some View {
        configuration.label
            .fontWeight(.medium)
            .foregroundStyle(.white)
//            .frame(height: 44)
            .frame(height: 60)
//            .frame(maxWidth: .infinity)
            .background(isEnabled ? .blue : .gray.opacity(0.3))
//            .clipShape(RoundedRectangle(cornerRadius: 4))
            .clipShape(Circle())
            .opacity(configuration.isPressed && isEnabled ? 0.8 : 1.0)
    }
}

struct CardStackNavigationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        CardStackNavigationButton(configuration: configuration)
    }
}
