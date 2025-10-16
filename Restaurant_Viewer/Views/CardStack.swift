import SwiftUI

struct CardStack: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @Binding var restaurants: [Restaurant]
    @Binding var currentRestaurantIndex: Int
    
    var body: some View {
        ZStack {
            ForEach(restaurants) { restaurant in
                
                if let animationPhase = restaurant.animationPhase {
                    CardView(restaurant: restaurant)
                        .scaleEffect(animationPhase.scale)
                        .opacity(CGFloat(animationPhase.opacity))
                        .zIndex(animationPhase.zIndex)
                        .offset(x: animationPhase.xOffset(verticalSizeClass, horizontalSizeClass))
                }
            }
        }
        .onAppear { setPositions() }
        .onChange(of: currentRestaurantIndex) { withAnimation { setPositions() } }
    }
    
    
    //MARK: - Functions
    
    /// Updates the animation phase for each visible restaurant card in the stack.
    ///
    /// This method determines which restaurant cards are currently visible
    /// or nearby in the stack and assigns them an appropriate `animationPhase`.
    /// The animation phase controls how each card appears, transitions,
    /// or animates (e.g. `.current`, `.next`, `.previous`, etc.).
    ///
    /// - Note: Cards outside the visible range have their animation phase reset to `nil`.
    /// - Important: This method safely checks array bounds to prevent index out-of-range errors.
    private func setPositions() {
        guard !restaurants.isEmpty else { return }
        
        var lowerBound: Int { currentRestaurantIndex - 2 }
        var previousIndex: Int { currentRestaurantIndex - 1 }
        var nextIndex: Int { currentRestaurantIndex + 1 }
        var lastIndex: Int { currentRestaurantIndex + 2 }
        var upperBound: Int { currentRestaurantIndex + 3 }
        
        if lowerBound >= 0 {
            restaurants[lowerBound].animationPhase = nil
        }
        if previousIndex >= 0 {
            restaurants[previousIndex].animationPhase = .previous
        }
        if currentRestaurantIndex >= 0 && currentRestaurantIndex < restaurants.count {
            restaurants[currentRestaurantIndex].animationPhase = .current
        }
        if nextIndex < restaurants.count {
            restaurants[nextIndex].animationPhase = .next
        }
        if lastIndex < restaurants.count {
            restaurants[lastIndex].animationPhase = .last
        }
        if upperBound < restaurants.count {
            restaurants[upperBound].animationPhase = nil
        }
    }
}
