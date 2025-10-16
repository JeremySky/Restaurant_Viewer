import SwiftUI

struct CardView: View {
    
    //MARK: - Environment
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.userInterfaceIdiom) var userInterfaceIdiom: UIUserInterfaceIdiom
    
    //MARK: - State
    @State var isFavorite: Bool
    
    //MARK: - Input
    let restaurant: Restaurant
    
    //MARK: - Init
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        self.isFavorite = UserDefaultsServices.shared.getIsFavorite(forKey: restaurant.id)
    }
    
    //MARK: - Body
    var body: some View {
        ZStack {
    
            //MARK: - Image & Placeholders
            Group {
                if let imageURL = restaurant.imageURL, !imageURL.isEmpty, let url = URL(string: imageURL) {
                    
                //MARK: Image State - Loaded
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .overlay { loadedOverlayGradient }
                        
                //MARK: Image State - Loading
                    } placeholder: {
                        ProgressView()
                            .frame(width: width, height: height)
                            .overlay { loadingOverlayGradient }
                    }
                    
                //MARK: Image State - Empty
                } else {
                    VStack {
                        Image(systemName: "takeoutbag.and.cup.and.straw")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .foregroundStyle(emptyImageForegroundColor)
                        Text("No Image")
                            .bold()
                            .foregroundStyle(emptyImageForegroundColor)
                    }
                    .frame(width: width, height: height)
                    .overlay { emptyOverlayGradient }
                }
            }
            .background(backgroundColor)
            
            
            //MARK: - Restaurant Details
            VStack(alignment: .leading) {
                Text(restaurant.name ?? "Unknown Restaurant")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .lineLimit(1)
                HStack {
                    Image(RatingImage.getResource(for: restaurant.rating))
                    Text(restaurant.formattedRating).font(.headline).fontWeight(.light)
                    Text("(\(restaurant.formattedDistance) mi)").font(.caption)
                }
            }
            .foregroundStyle(.white)
            .padding()
            .frame(width: width, height: height, alignment: .bottomLeading)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            
            
            //MARK: - Favorite Button
            Button {
                toggleIsFavorite()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 28)
                    .foregroundStyle(isFavorite ? .red : isNotFavoriteColor)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.7))
                    .clipShape(Circle())
            }
            .padding()
            .frame(width: width, height: height, alignment: deviceLayoutType == .narrowTall ? .topTrailing : .bottomTrailing)
            
            
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 5))

    }
    //MARK: - Functions
    private func toggleIsFavorite() {
        UserDefaultsServices.shared.setIsFavorite(!isFavorite, forKey: restaurant.id)
        self.isFavorite.toggle()
    }
    
    //MARK: - Layout / Style Constraints
    private var deviceLayoutType: ViewLayoutType {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return .wideTall
        } else if verticalSizeClass == .regular {
            return .narrowTall
        } else {
            return .wideShort
        }
    }
    
    private var width: CGFloat {
        switch deviceLayoutType {
        case .wideTall:
            return 600
        case .narrowTall:
            return 300
        case .wideShort:
            return 450
        case .unsupported:
            fatalError("\(#line)) \(#fileID).\(#function)\nUnsupported user interface idiom: \(userInterfaceIdiom)")
        }
    }
    
    private var height: CGFloat {
        switch deviceLayoutType {
        case .wideTall:
            return 400
        case .narrowTall:
            return 350
        case .wideShort:
            return 250
        case .unsupported:
            fatalError("\(#line)) \(#fileID).\(#function)\nUnsupported user interface idiom: \(userInterfaceIdiom)")
        }
    }
    
    private var emptyImageForegroundColor: Color {
        return .secondary
    }
    
    private var backgroundColor: Color {
        colorScheme == .light ? .white : .gray
    }
    
    private var loadedOverlayGradient: LinearGradient {
        var colors: [Color]!
        switch deviceLayoutType {
            
        case .wideTall:
            colors = [
                .clear,
                .clear,
                .clear,
                .black.opacity(0.4),
                .black
            ]
            
        case .narrowTall:
            colors = [
                .clear,
                .clear,
                .clear,
                .black.opacity(0.4),
                .black
            ]
            
        case .wideShort:
            colors = [
                .clear,
                .clear,
                .clear,
                .black.opacity(0.4),
                .black
            ]
            
        case .unsupported:
            fatalError("\(#line)) \(#fileID).\(#function)\nUnsupported user interface idiom: \(userInterfaceIdiom)")
        }
        
        return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
    }
    
    private var loadingOverlayGradient: LinearGradient {
        var colors: [Color]!
        switch deviceLayoutType {
            
        case .wideTall:
            colors = [
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.1) : .black.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.4) : .black.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.9) : .black.opacity(0.8)
            ]
            
        case .narrowTall:
            colors = [
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.1) : .black.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.34) : .black.opacity(0.4),
                colorScheme == .light ? .gray : .black.opacity(0.8)
            ]
            
        case .wideShort:
            colors = [
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.24) : .black.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.5) : .black.opacity(0.4),
                colorScheme == .light ? .gray.opacity(0.9) : .black.opacity(0.8)
            ]
            
        case .unsupported:
            fatalError("\(#line)) \(#fileID).\(#function)\nUnsupported user interface idiom: \(userInterfaceIdiom)")
        }
        
        return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
    }
    
    private var emptyOverlayGradient: LinearGradient {
        var colors: [Color]!
        switch deviceLayoutType {
            
        case .wideTall:
            colors = [
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.1) : .black.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.3) : .black.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.9) : .black.opacity(0.8)
            ]
            
        case .narrowTall:
            colors = [
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.34) : .black.opacity(0.2),
                colorScheme == .light ? .gray : .black.opacity(0.8)
            ]
            
        case .wideShort:
            colors = [
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                .gray.opacity(0.1),
                colorScheme == .light ? .gray.opacity(0.24) : .black.opacity(0.14),
                colorScheme == .light ? .gray.opacity(0.5) : .black.opacity(0.4),
                colorScheme == .light ? .gray.opacity(0.9) : .black.opacity(0.8)
            ]
            
        case .unsupported:
            fatalError("\(#line)) \(#fileID).\(#function)\nUnsupported user interface idiom: \(userInterfaceIdiom)")
        }
        
        return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
    }
    
    private var isNotFavoriteColor: Color {
        return colorScheme == .light ? .secondary.opacity(0.5) : .black.opacity(0.5)
    }
    
}


#Preview("CardView - Loaded") {
    CardView(restaurant: .mock(.loaded))
}
#Preview("CardView - Loading") {
    CardView(restaurant: .mock(.loading))
}
#Preview("CardView - Empty") {
    CardView(restaurant: .mock(.empty))
}

