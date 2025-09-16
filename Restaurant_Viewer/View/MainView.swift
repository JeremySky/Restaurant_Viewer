import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            
            Spacer()
            if viewModel.coordinate != nil && viewModel.restaurants.count > 0 {
//                ScrollViewCardStack(viewModel: viewModel)
                CardStack(viewModel: viewModel)
            }
            Spacer()
            
            Divider()
            
            if viewModel.coordinate == nil {
                Button {
                    viewModel.load()
                } label: {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(height: 44)
                        .overlay {
                            Text(viewModel.errorMessage == nil ? "Load Restaurants Near Me" : "Try again")
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                }
                .padding()
            } else {
                HStack {
                    Button {
                        viewModel.prevRestaurant()
                    } label: {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 44)
                            .overlay {
                                Text("Previous")
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                            }
                    }
                    .disabled(viewModel.restaurants.isEmpty || viewModel.currentRestaurantIndex == 0)
                    .allowsHitTesting(!viewModel.isLoading)
                    
                    Button {
                        viewModel.nextRestaurant()
                    } label: {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(height: 44)
                            .overlay {
                                Text("Next")
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                            }
                    }
                    .disabled(viewModel.currentRestaurantIndex >= viewModel.restaurants.count - 1)
                    .allowsHitTesting(!viewModel.isLoading)
                }
                .padding()
            }
        }
    }
}

#Preview {
    MainView(viewModel: .mock)
}
