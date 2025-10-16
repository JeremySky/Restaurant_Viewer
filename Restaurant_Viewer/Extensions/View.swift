import SwiftUI

extension View where Self == Text {
    func badgeStyle() -> some View {
        self
            .bold()
            .foregroundStyle(.blue.opacity(0.8))
            .padding(.vertical, 6)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.blue.opacity(0.8))
                    .fill(.blue.opacity(0.2))
            )
    }
}

extension View where Self == Text {
    func filterSheetHeaderStyle() -> some View {
        self
            .font(.title)
            .fontWeight(.bold)
            .kerning(1)
    }
}
