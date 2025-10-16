import SwiftUI

struct RestaurantCategoryPicker: View {
    @Binding var selection: RestaurantCategory?
    private var columns: Int {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 4
        } else {
            return 3
        }
    }
    private let categories = RestaurantCategory.allCases
    
    var body: some View {
        VStack(spacing: 10) {
            // Split categories into rows of 3
            ForEach(0..<rowsCount(), id: \.self) { rowIndex in
                HStack {
                    ForEach(categoriesForRow(rowIndex), id: \.self) { restaurantCategory in
                        Button {
                            withAnimation(.easeInOut) {
                                selection = selection != restaurantCategory ? restaurantCategory : nil
                            }
                        } label: {
                            RestaurantCategoryButtonLabel(selection: $selection, restaurantCategory: restaurantCategory)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func rowsCount() -> Int {
        Int(ceil(Double(categories.count) / Double(columns)))
    }
    
    private func categoriesForRow(_ row: Int) -> [RestaurantCategory] {
        let start = row * columns
        let end = min(start + columns, categories.count)
        return Array(categories[start..<end])
    }
}

struct RestaurantCategoryButtonLabel: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @Binding var selection: RestaurantCategory?
    let restaurantCategory: RestaurantCategory
    
    var body: some View {
        VStack(spacing: 2) {
            Text(restaurantCategory.icon)
                .font(.system(size: 30))
            Text(restaurantCategory.rawValue.capitalized)
                .font(.system(size: 10))
                .foregroundStyle(selection == restaurantCategory ? .blue : .primary)
        }
        .frame(width: buttonWidth, height: buttonHeight)
        .background(
            RoundedRectangle(cornerRadius: 2)
                .stroke(selection == restaurantCategory ? .blue.opacity(0.8) : .gray.opacity(0.9))
                .fill(selection == restaurantCategory ? .blue.opacity(0.2) : .clear)
        )
    }
    
    private var buttonWidth: CGFloat {
        switch (verticalSizeClass) {
        case (.compact):
            return 100
        default:
            if horizontalSizeClass == .compact {
                return 90
            } else {
                return 80
            }
        }
    }
        
    private var buttonHeight: CGFloat {
        switch (verticalSizeClass) {
        case (.compact):
            return 80
        default:
            if horizontalSizeClass == .compact {
                return 70
            } else {
                return 80
            }
        }
    }
}
