import SwiftUI

struct FilterSheetView: View {
    
    //MARK: - Environment
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    //MARK: - Binding
    @Binding var isLoading: Bool
    @Binding var isPresenting: Bool
    
    //MARK: - State
    @State var selectedSortCriteria: SortCriteria?
    @State var selectedRestaurantCategory: RestaurantCategory?
    
    
    let fetchAction: (SortCriteria?, RestaurantCategory?) -> Void
    
    var body: some View {
        if verticalSizeClass == .regular {
            VStack {
                //MARK: - Sort & Filter
                sectionHeader(text: "Sort")
                    .padding(.bottom)
                    .overlay {
                        Button(action: { isPresenting = false }) {
                            Image(systemName: "xmark")
                                .fontWeight(.black)
                        }
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                SortCriteriaPicker(selection: $selectedSortCriteria)/*.padding(.vertical, 25)*/
                
                Divider().padding(.vertical, 15)
                
                sectionHeader(text: "Filter")
                RestaurantCategoryPicker(selection: $selectedRestaurantCategory)
                    .frame(maxHeight: .infinity)
                
                
                //MARK: - Confirm
                Button {
                    fetchAction(selectedSortCriteria, selectedRestaurantCategory)
                    self.isPresenting = false
                } label: {
                    Text("Confirm")
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
            }
            .padding(horizontalSizeClass == .regular ? 0 : 40)
            
        } else {
            HStack {
                VStack {
                    
                    sectionHeader(text: "Filter")
                    RestaurantCategoryPicker(selection: $selectedRestaurantCategory)
                        .frame(maxHeight: .infinity)
                    
                }
                .padding()
                
                Divider().padding(.bottom, 15)
                
                VStack {
                    //MARK: - Sort & Filter
                    Button(action: { isPresenting = false }) {
                        Image(systemName: "xmark")
                            .fontWeight(.black)
                    }
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    VStack {
                        sectionHeader(text: "Sort")
                        SortCriteriaPicker(selection: $selectedSortCriteria).padding(.vertical, 25)
                    }
                    .frame(maxHeight: .infinity)
                    
                    
                    //MARK: - Confirm
                    Button {
                        fetchAction(selectedSortCriteria, selectedRestaurantCategory)
                        self.isPresenting = false
                    } label: {
                        Text("Confirm")
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isLoading)
                    
                }
                .padding()
                
            }
        }
        
        
        
    }
    
    //MARK: - View Builders
    @ViewBuilder private func sectionHeader(text: String) -> some View {
        Text(text)
            .font(.title)
            .fontWeight(.bold)
            .kerning(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    @Previewable var viewModel: ViewModel = ViewModel(
        locationService: MockLocationService(scenario: .success),
        searchService: MockRestaurantSearchService(scenario: .success)
    )
    
    NavigationStack {
        MainView(viewModel: viewModel)
    }
}
