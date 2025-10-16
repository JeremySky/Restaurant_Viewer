import SwiftUI

enum CardAnimationPhase {
    case previous, current, next, last
    
    func xOffset(_ verticalSizeClass: UserInterfaceSizeClass?, _ horizontalSizeClass: UserInterfaceSizeClass?) -> CGFloat {
        switch self {
        case .previous:
            return -UIScreen.main.bounds.width
        case .current:
            return 0
        case .next:
            return horizontalSizeClass == .compact ? 20 : verticalSizeClass == .compact ? 45 : 60
        case .last:
            return horizontalSizeClass == .compact ? 40 : verticalSizeClass == .compact ? 75 : 110
        }
    }
    
    var scale: Double {
        switch self {
        case .previous:
            0.6
        case .current:
            1
        case .next:
            0.95
        case .last:
            0.90
        }
    }
    
    var zIndex: Double {
        switch self {
        case .previous:
            return 4
        case .current:
            return 3
        case .next:
            return 2
        case .last:
            return 1
        }
    }
    
    var opacity: CGFloat {
        switch self {
        case .previous:
            return 0.8
        case .current:
            return 1
        case .next:
            return 0.8
        case .last:
            return 0.2
        }
    }
}
