import SwiftUI

struct MainTabView: View {
   
    @EnvironmentObject var viewm: HomeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
        TabView {
                   Tab("Explore", systemImage: "globe") {
                       HomeView()
                   }

                   Tab("My Portfolio", systemImage: "briefcase.circle.fill") {
                       PortfolioView()
                   }
           
                   Tab("Profile", systemImage: "person.fill") {
                       ProfileView()
                   }
            Tab(role: .search){
              
                    CompleteSearchBar(
                        searchText: $viewm.searchText,
                        filteredStock: viewm.filteredStocks)
                        }
            }
        .task {
                    // This runs once when the view appears.
                    // Check if the user is authenticated and then fetch the data.
                    // This ensures AuthViewModel.user is populated first.
                    if authViewModel.user != nil {
                        await viewm.fetchPortfolioStocks()
                    }
                }
            
            .tabViewStyle(.automatic)
           // .tabBarMinimizeBehavior(.onScrollDown)
    }
}


#Preview {
    NavigationStack{
        MainTabView()
            .environmentObject(HomeViewModel(authViewModel: AuthViewModel()))
    }
}

