import SwiftUI

@main
struct Restaurant_ViewerApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView(viewModel: ViewModel())
            }
        }
    }
}
