import Foundation

enum RatingImage {
    case zero, half, one, oneHalf, two, twoHalf, three, threeHalf, four, fourHalf, five
//    
//    var resource: String {
//        switch self {
//        case .zero:
//            "Review_Ribbon_small_16_0"
//        case .half:
//            "Review_Ribbon_small_16_half"
//        case .one:
//            "Review_Ribbon_small_16_1"
//        case .oneHalf:
//            "Review_Ribbon_small_16_1_half"
//        case .two:
//            "Review_Ribbon_small_16_2"
//        case .twoHalf:
//            "Review_Ribbon_small_16_2_half"
//        case .three:
//            "Review_Ribbon_small_16_3"
//        case .threeHalf:
//            "Review_Ribbon_small_16_3_half"
//        case .four:
//            "Review_Ribbon_small_16_4"
//        case .fourHalf:
//            "Review_Ribbon_small_16_4_half"
//        case .five:
//            "Review_Ribbon_small_16_5"
//        }
//    }
    
    var resource: String {
        switch self {
        case .zero:
            "Review_Ribbon_medium_20_0"
        case .half:
            "Review_Ribbon_medium_20_half"
        case .one:
            "Review_Ribbon_medium_20_1"
        case .oneHalf:
            "Review_Ribbon_medium_20_1_half"
        case .two:
            "Review_Ribbon_medium_20_2"
        case .twoHalf:
            "Review_Ribbon_medium_20_2_half"
        case .three:
            "Review_Ribbon_medium_20_3"
        case .threeHalf:
            "Review_Ribbon_medium_20_3_half"
        case .four:
            "Review_Ribbon_medium_20_4"
        case .fourHalf:
            "Review_Ribbon_medium_20_4_half"
        case .five:
            "Review_Ribbon_medium_20_5"
        }
    }
    
    static func getResource(for rating: Double?) -> String {
        guard let rating else { return RatingImage.zero.resource }
        let roundedRating = (rating * 2).rounded() / 2
        var ratingImage: RatingImage!
        
        switch roundedRating {
        case 0:
            ratingImage = .zero
        case 0.5:
            ratingImage = .half
        case 1:
            ratingImage = .one
        case 1.5:
            ratingImage = .oneHalf
        case 2:
            ratingImage = .two
        case 2.5:
            ratingImage = .twoHalf
        case 3:
            ratingImage = .three
        case 3.5:
            ratingImage = .threeHalf
        case 4:
            ratingImage = .four
        case 4.5:
            ratingImage = .fourHalf
        case 5:
            ratingImage = .five
        default:
            ratingImage = .zero
        }
        
        return ratingImage.resource
    }
}
