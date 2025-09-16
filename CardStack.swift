//
//  CardStack.swift
//  Restaurant_Viewer
//
//  Created by Jeremy Manlangit on 9/11/25.
//

import SwiftUI

//struct ScrollViewCardStack: View {
//    
//    typealias animationProperties = (rotation: Angle, offset: (x: CGFloat, y: CGFloat))
//    
//    @ObservedObject var viewModel: ViewModel
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ScrollViewReader { proxy in
//                ScrollView(.horizontal) {
//                    LazyHStack(spacing: 0) {
//                        ForEach(viewModel.restaurants, id: \.id) { restaurant in
//                            RestaurantCard(restaurant: restaurant)
//                                .frame(width: geometry.size.width)
//                                .id(restaurant.id)
//                        }
//                    }
//                }
//                .allowsHitTesting(false)
//                .onChange(of: viewModel.currentRestaurantIndex) { oldValue, newValue in
//                    let currentId = viewModel.restaurants[viewModel.currentRestaurantIndex].id
//                    withAnimation {
//                        proxy.scrollTo(currentId)
//                    }
//                }
//            }
//        }
//    }
//}

class CardAnimationProperties: ObservableObject {
    @Published var restaurant: Restaurant?
    @Published var position: CardPosition
    var rotation: Angle { self.position.rotation }
    var offset: (x: CGFloat, y: CGFloat) { self.position.offset }
    var zIndex: Double { self.position.zIndex }
    var opacity: CGFloat { self.position.opacity }
    
    init(restaurant: Restaurant?, position: CardPosition) {
        self.restaurant = restaurant
        self.position = position
    }

    func next() {
        switch position {
        case .previous:
            self.position = .last
        case .current:
            self.position = .previous
        case .next:
            self.position = .current
        case .last:
            self.position = .next
        case .extra:
            self.position = .last
        }
    }
    
    func previous() {
        switch position {
        case .previous:
            self.position = .current
        case .current:
            self.position = .next
        case .next:
            self.position = .last
        case .last:
            self.position = .previous
        case .extra:
            fatalError("CardAnimationProperties.previous(): unexpected case .extra")
        }
    }
}

enum CardPosition {
    case previous, current, next, last
    case extra // only used at CardStack's init
    
    var rotation: Angle {
        switch self {
        case .previous:
            return .degrees(0)
        case .current:
            return .degrees(0)
        case .next:
            return .degrees(2)
        default:
            return .degrees(4)
        }
    }
    
    var offset: (x: CGFloat, y: CGFloat) {
        switch self {
        case .previous:
            return (-400, 0)
        case .current:
            return (0, 0)
        case .next:
            return (0, 0)
        default:
            return (0, 0)
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
        case .extra:
            return 0
        }
    }
    
    var opacity: CGFloat {
        switch self {
        case .previous:
            return 1
        case .current:
            return 1
        case .next:
            return 0.5
        case .last:
            return 0.2
        case .extra:
            return 0
        }
    }
}

struct CardStack: View {
    @ObservedObject var viewModel: ViewModel
    
    typealias cardAView = RestaurantCard
    typealias cardBView = RestaurantCard
    typealias cardCView = RestaurantCard
    typealias cardDView = RestaurantCard
    
    @StateObject var cardAAnimationProperties: CardAnimationProperties
    @StateObject var cardBAnimationProperties: CardAnimationProperties
    @StateObject var cardCAnimationProperties: CardAnimationProperties
    @StateObject var cardDAnimationProperties: CardAnimationProperties
    
    @State var numCardsDoneAnimating: Int = 0
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        
        self._cardAAnimationProperties = StateObject(wrappedValue: CardAnimationProperties(restaurant: viewModel.restaurants[0], position: .current))
        self._cardBAnimationProperties = StateObject(wrappedValue: CardAnimationProperties(restaurant: viewModel.restaurants[1], position: .next))
        self._cardCAnimationProperties = StateObject(wrappedValue: CardAnimationProperties(restaurant: viewModel.restaurants[2], position: .last))
        self._cardDAnimationProperties = StateObject(wrappedValue: CardAnimationProperties(restaurant: viewModel.restaurants[3], position: .extra))
    }
    
    var body: some View {
        ZStack {
            //TODO: implement next & previous animation
            // on change of viewModel.currentCardIndex:
            // if +: card in prevPosition -> thirdPosition & becomes fourthCard in line
            // if -: card in fourthCard -> prevPosition & becomes previousCard
            if let restaurantA = cardAAnimationProperties.restaurant {
                cardAView(restaurant: restaurantA)
                    .rotationEffect(cardAAnimationProperties.rotation, anchor: .bottomTrailing)
                    .offset(x: cardAAnimationProperties.offset.x, y: cardAAnimationProperties.offset.y)
                    .zIndex(cardAAnimationProperties.zIndex)
                    .opacity(cardAAnimationProperties.opacity)
            }
            if let restaurantB = cardBAnimationProperties.restaurant {
                cardBView(restaurant: restaurantB)
                    .rotationEffect(cardBAnimationProperties.rotation, anchor: .bottomTrailing)
                    .offset(x: cardBAnimationProperties.offset.x, y: cardBAnimationProperties.offset.y)
                    .zIndex(cardBAnimationProperties.zIndex)
                    .opacity(cardBAnimationProperties.opacity)
            }
            if let restaurantC = cardCAnimationProperties.restaurant {
                cardCView(restaurant: restaurantC)
                    .rotationEffect(cardCAnimationProperties.rotation, anchor: .bottomTrailing)
                    .offset(x: cardCAnimationProperties.offset.x, y: cardCAnimationProperties.offset.y)
                    .zIndex(cardCAnimationProperties.zIndex)
                    .opacity(cardCAnimationProperties.opacity)
            }
            if let restaurantD = cardDAnimationProperties.restaurant {
                cardDView(restaurant: restaurantD)
                    .rotationEffect(cardDAnimationProperties.rotation, anchor: .bottomTrailing)
                    .offset(x: cardDAnimationProperties.offset.x, y: cardDAnimationProperties.offset.y)
                    .zIndex(cardDAnimationProperties.zIndex)
                    .opacity(cardDAnimationProperties.opacity)
            }
        }
        .onChange(of: viewModel.currentRestaurantIndex) { oldValue, newValue in
            let array = [cardAAnimationProperties, cardBAnimationProperties, cardCAnimationProperties, cardDAnimationProperties]

            if newValue > oldValue {
                for animationProperties in array {
                    if animationProperties.position == .previous {
                        let index = newValue + 2
                        
                        if index < viewModel.restaurants.count {
                            animationProperties.restaurant = viewModel.restaurants[index]
                        } else {
                            animationProperties.restaurant = nil
                        }
            
                        animationProperties.next()
                    } else {
                        withAnimation {
                            animationProperties.next()
                        } completion: {
                            numCardsDoneAnimating += 1
                        }
                    }
                }
            } else {
                for animationProperties in array {
                    if animationProperties.position == .last {
                        if newValue == 0 {
                            let index = newValue + 3
                            
                            if index < viewModel.restaurants.count {
                                animationProperties.restaurant = viewModel.restaurants[index]
                            } else {
                                animationProperties.restaurant = nil
                            }
                            
                            animationProperties.previous()
                        } else {
                            animationProperties.restaurant = viewModel.restaurants[newValue - 1]
                            animationProperties.previous()
                        }
                    } else {
                        withAnimation {
                            animationProperties.previous()
                        } completion: {
                            numCardsDoneAnimating += 1
                        }
                    }
                }
            }
        }
        .onChange(of: numCardsDoneAnimating) { oldValue, newValue in
            if newValue >= 3 { viewModel.isLoading = false }
        }
    }
}

#Preview {
//    ScrollViewCardStack(viewModel: .mock)
    CardStack(viewModel: .mock)
}
