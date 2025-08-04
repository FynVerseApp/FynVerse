import SwiftUI

// This is the model the SeeMoreButton will push
struct SeeMoreStocks: Hashable {
    let stocks: [StockModel]
}


// This is the corrected destination view for the SeeMoreButton


struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                
                VStack {
                    // Check if the stock data has been loaded
                        if vm.allStocks.isEmpty {
                            // Display a loading indicator while fetching data
                            ProgressView()
                                .tint(Color.theme.accent)
                        } else {
                            
                            if let stock = vm.allStocks.first {
                                StatisticsView(nifty50: stock)
                            }
                            
                            // CORRECT: Use NavigationLink with a value for the search destination
                            NavigationLink(value: "search") {
                                // This is the label of the NavigationLink—what the user sees
                                SearchBarView()
                            }
                            ScrollView {
                                VStack(spacing: 24) {
                                    TopGainersView
                                    TopLoosersView
                                    ExploreView
                                }
                                .padding(.top, 8)
                                .padding(.bottom, 16)
                                Text("Fynverse private limited")
                                    .font(.title3)
                                    .fontWeight(.light)
                                Text("fynverse@gmail.com")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                            }
                            .refreshable {
                                await vm.fetchStocks()
                            }
                        }
                }
                .onAppear {
                    Task {
                        await vm.fetchStocks()
                    }
                }
            }
            .navigationDestination(for: String.self) { value in
                // This closure is only called when a String is pushed onto the stack
                // You can check the value to determine which view to present
                if value == "search" {
                    CompleteSearchBar(searchText: $vm.searchText, filteredStock: vm.filteredStocks)
                }
            }
            // CORRECT: All navigation destinations are now defined here at the top level
            .navigationDestination(for: StockModel.self) { stock in
                DetailView(stock: stock, DBStock: nil)
            }
            
            // CORRECT: Add a navigationDestination for an array of StockModel
            .navigationDestination(for: [StockModel].self) { stocks in
                SeeMoreView(resultantStocks: stocks, title: "all Stocks")
            }
        }
    }
    
    // All of the following sub-views remain correct, as they only contain NavigationLink(value: ...)
    private var TopLoosersView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Top Losers")
                    .font(.headline)
                    .bold()
                Spacer()
                SeeMoreButton(resultantStocks: vm.topLooserStocks)
            }
            .foregroundStyle(Color.theme.accent)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(vm.topLooserStocks.prefix(4)) { stock in
                        NavigationLink(value: stock) {
                            StockExploreView(stock: stock)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.theme.background.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
    
    var TopGainersView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Top Gainers")
                    .font(.headline)
                    .bold()
                Spacer()
                SeeMoreButton(resultantStocks: vm.topGainerStocks)
            }
            .foregroundStyle(Color.theme.accent)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(vm.topGainerStocks.prefix(4)) { stock in
                        NavigationLink(value: stock) {
                            StockExploreView(stock: stock)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.theme.background.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
    
    var ExploreView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Explore NIFTY50 Stocks")
                    .font(.headline)
                    .bold()
                Spacer()
                SeeMoreButton(resultantStocks: vm.allStocks)
            }
            .foregroundStyle(Color.theme.accent)
            
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 12
            ) {
                ForEach(vm.allStocks.dropFirst().prefix(6)) { stock in
                    NavigationLink(value: stock) {
                        StockExploreView(stock: stock)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(Color.theme.background.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal, 16)
    }
}


