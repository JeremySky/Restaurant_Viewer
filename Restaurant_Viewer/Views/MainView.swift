import SwiftUI

struct MainView: View {
    
    //MARK: - Environment Objects
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    //MARK: - State Objects
    @StateObject var viewModel: ViewModel
    
    //MARK: - State Properties
    @State private var showCardStack: Bool = false
    
    var body: some View {
        VStack {
            //MARK: - Card Stack
            VStack {
                // View State - Empty...
                if viewModel.restaurants.isEmpty && !viewModel.isLoading {
                    Image(systemName: "exclamationmark.bubble")
                    Text("No Restaurants Nearby")
                    
                // View State - Loading...
                } else if viewModel.restaurants.isEmpty && viewModel.isLoading {
                    ProgressView()
                    Text(viewModel.coordinate == nil ? "Locating..." : "Finding restaurants....")
                    
                // View State - Loaded
                } else {
                    CardStack(restaurants: $viewModel.restaurants, currentRestaurantIndex: $viewModel.currentRestaurantIndex)
                        .transition(.cardStackSlide)
                }
            }
            .foregroundStyle(.secondary)
            .frame(maxHeight: .infinity)
            .animation(.spring(), value: viewModel.restaurants.isEmpty)
            
            
            //MARK: - Card Navigation Buttons
            HStack {
                Button { viewModel.prevRestaurant() } label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .resizable()
                        .scaledToFit()
                }
                .disabled(viewModel.restaurants.isEmpty || viewModel.currentRestaurantIndex == 0)
                .allowsHitTesting(!viewModel.filterIsPresenting)
                
                HStack {
                    switch verticalSizeClass {
                    case .regular:
                        VStack {
                            if let sortBy = viewModel.sortCriteria {
                                Text("Sorted by: \(sortBy.rawValue.capitalized)")
                                    .badgeStyle()
                            }
                            if let category = viewModel.restaurantCategory {
                                Text("\(category.icon) \(category.rawValue) ")
                                    .badgeStyle()
                            }
                        }
                    default:
                        if let sortBy = viewModel.sortCriteria {
                            Text("Sorted by: \(sortBy.rawValue.capitalized)")
                                .badgeStyle()
                        }
                        if let category = viewModel.restaurantCategory {
                            Text("\(category.icon) \(category.rawValue) ")
                                .badgeStyle()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Button { viewModel.nextRestaurant() } label: {
                    Image(systemName: "chevron.right.circle.fill")
                        .resizable()
                        .scaledToFit()
                }
                .disabled(viewModel.currentRestaurantIndex >= viewModel.restaurants.count - 1)
                .allowsHitTesting(!viewModel.filterIsPresenting)
            }
            .frame(height: 44)
            .padding(.horizontal, 30)
        }
        .background(colorScheme == .light ? .clear : .gray.opacity(0.2))
        .background(ignoresSafeAreaEdges: .all)
        
        
        //MARK: - View Lifecycle Modifiers
        .onAppear { viewModel.fetchRestaurants() }
        .onChange(of: viewModel.filterIsPresenting) { _, newValue in
            if newValue == true { showCardStack = false } // Set to true in Filter View
        }
        
        
        //MARK: - Filter Sheet
        .sheet(isPresented: $viewModel.filterIsPresenting, content: {
                FilterSheetView(
                    isLoading: $viewModel.isLoading,
                    isPresenting: $viewModel.filterIsPresenting,
                    selectedSortCriteria: viewModel.sortCriteria,
                    selectedRestaurantCategory: viewModel.restaurantCategory,
                    fetchAction: { viewModel.fetchRestaurants(sortCriteria: $0, restaurantCategory: $1)}
                )
        })
        
        
        //MARK: - Alert
        .alert("Uh oh!",
               isPresented: Binding($viewModel.errorMessage),
               actions: {
            if viewModel.restaurants.isEmpty {
                Button("Try Again", action: { viewModel.fetchRestaurants() })
            } else {
                Button("OK", action: { viewModel.errorMessage = nil })
            }
        },
               message: {
            Text(viewModel.errorMessage ?? "")
        })
        
        
        //MARK: - Navigation & Toolbar
        .navigationTitle("Restaurant Viewer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { viewModel.filterIsPresenting = true } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                }
            }
        }
    }
}


#Preview {
    @Previewable var viewModel: ViewModel = ViewModel(
        locationService: MockLocationService(scenario: .preloaded),
        searchService: MockRestaurantSearchService(scenario: .preloaded)
    )
    
    NavigationStack {
        MainView(viewModel: viewModel)
    }
}

extension AnyTransition {
    static var cardStackSlide: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .trailing)
    )
    
    static var cardTransition: AnyTransition = .asymmetric(
        insertion: .identity,
        removal: .move(edge: .leading)
    )
}
