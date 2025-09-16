//
//  RestaurantCard.swift
//  Restaurant_Viewer
//
//  Created by Jeremy Manlangit on 9/10/25.
//

import SwiftUI

struct RestaurantCard: View {
    
    let restaurant: Restaurant
    let toggleIsFavoriteAction: (() -> Bool?)
    @State var isFavorite: Bool
    
    init(restaurant: Restaurant, toggleIsFavoriteAction: @escaping () -> Bool? = { nil }, isFavorite: Bool = false) {
        self.restaurant = restaurant
        self.toggleIsFavoriteAction = toggleIsFavoriteAction
        self.isFavorite = isFavorite
    }
    
    var body: some View {
        VStack {
            if let imageURL = restaurant.imageURL, !imageURL.isEmpty, let url = URL(string: imageURL) {
                
                AsyncImage(url: url) { image in
                    
                    GeometryReader { geo in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: 300)
                    }
                    .frame(height: 300)
                    .clipped()
                    
                    
                } placeholder: {
                    
                    ProgressView()
                        .scaledToFit()
                        .padding(70)
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .foregroundStyle(.secondary.opacity(0.3))
                        .background(.secondary.opacity(0.15))
                    
                }
            } else {
                
                VStack {
                    Image(systemName: "takeoutbag.and.cup.and.straw")
                        .resizable()
                        .scaledToFill()
                        .fontWeight(.light)
                    Text("No Image")
                }
                .padding(70)
                .frame(height: 300)
                .foregroundStyle(.secondary.opacity(0.3))
                .background(.secondary.opacity(0.15))
                
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(restaurant.name ?? "Unknown Restaurant")
                            .font(.headline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                    }
                    .padding(.top, 8)
                    HStack {
                        Image(reviewAsset.rawValue)
                        Text(formattedRating)
                            .font(.caption)
                    }
                }
                Spacer()
                
                Button {
                    toggleIsFavorite()
                } label: {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 60, height: 45)
                        .foregroundStyle(.black.opacity(0.06))
                        .overlay(
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 30)
                                .foregroundStyle(isFavorite ? .red : .secondary.opacity(0.5))
                        )
                }
                .padding(.trailing, 6)
                
            }
            .padding(.horizontal, padding)
            .padding(.bottom, padding)
        }
        .frame(width: 300)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius) )
        .shadow(color: .black.opacity(0.1), radius: 50, x: 10, y: 10)
    }
    
    func toggleIsFavorite() {
        guard let isFavorite = toggleIsFavoriteAction() else { return }
        self.isFavorite = isFavorite
    }
    
    var padding: CGFloat = 14
    var cornerRadius: CGFloat = 10
    var formattedRating: String { String(format: "%.1f", restaurant.rating ?? 0) }
    var reviewAsset: RatingAsset {
        guard let rating = restaurant.rating else {
            return .zero
        }
        
        let rounded = (rating * 2).rounded() / 2
        
        switch rounded {
        case 0:
            return .zero
        case 0.5:
            return .half
        case 1:
            return .one
        case 1.5:
            return .oneHalf
        case 2:
            return .two
        case 2.5:
            return .twoHalf
        case 3:
            return .three
        case 3.5:
            return .threeHalf
        case 4:
            return .four
        case 4.5:
            return .fourHalf
        case 5:
            return .five
        default:
            return .zero
            
        }
    }
}

enum RatingAsset: String {
    case zero, half, one, oneHalf, two, twoHalf, three, threeHalf, four, fourHalf, five
    
    var rawValue: String {
        switch self {
        case .zero:
            "Review_Ribbon_small_16_0"
        case .half:
            "Review_Ribbon_small_16_half"
        case .one:
            "Review_Ribbon_small_16_1"
        case .oneHalf:
            "Review_Ribbon_small_16_1_half"
        case .two:
            "Review_Ribbon_small_16_2"
        case .twoHalf:
            "Review_Ribbon_small_16_2_half"
        case .three:
            "Review_Ribbon_small_16_3"
        case .threeHalf:
            "Review_Ribbon_small_16_3_half"
        case .four:
            "Review_Ribbon_small_16_4"
        case .fourHalf:
            "Review_Ribbon_small_16_4_half"
        case .five:
            "Review_Ribbon_small_16_5"
        }
    }
}

#Preview {
    @Previewable @State var isFavorite: Bool = false
    var mock: Restaurant {
        var val = Restaurant.mock
        val.imageURL = ""
        return val
    }
    
    RestaurantCard(restaurant: mock, toggleIsFavoriteAction: {
        isFavorite.toggle()
        return isFavorite
    })
}

