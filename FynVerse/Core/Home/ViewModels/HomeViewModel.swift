import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI // Use SwiftUI instead of SwiftUICore if you are using @EnvironmentObject

@MainActor
class HomeViewModel: ObservableObject {

    // Published properties for UI updates
    @Published var allStocks: [StockModel] = []
    @Published var topGainerStocks: [StockModel] = []
    @Published var topLooserStocks: [StockModel] = []
    @Published var searchText: String = "" {
        didSet {
            filterStocks()
        }
    }
    @Published var filteredStocks: [StockModel] = []
    @Published var portfolioStocks: [DBPortfolioStock] = []
    
    // Published properties for the portfolio summary
    @Published var totalInvestment: Double = 0
    @Published var portfolioValue: Double = 0
    @Published var totalGainLoss: Double = 0
    
    // Dependencies
    @Published var authViewModel: AuthViewModel
    private let manager = StockDataService.shared
    private let userManager = UserManager.shared

    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        // Note: You should call a fetch function here after the user is authenticated.
        // For example, in a `.task` modifier in your view.
    }
    
    // MARK: - Stock Data Fetching & Filtering
    
    func fetchStocks() async {
        let fetchedStocks = await manager.fetchStocks()
        if !fetchedStocks.isEmpty {
            await uploadStocks(fetchedStocks)
            allStocks = fetchedStocks
            print("✅ Stocks fetched from API and saved.")
        } else {
            allStocks = await fetchStocksFromFirestore()
        }
        
        filterStocks()
        filterGainerStocks()
        filterLooserStocks()
        
        // After fetching all stocks, also fetch portfolio stocks to enable full summary calculation
        await fetchPortfolioStocks()
    }

    func filterStocks() {
        guard !searchText.isEmpty else {
            filteredStocks = allStocks
            return
        }
        let lower = searchText.lowercased()
        filteredStocks = allStocks.filter {
            $0.symbol.lowercased().contains(lower) || $0.identifier.lowercased().contains(lower)
        }
    }
    
    func filterGainerStocks() {
        topGainerStocks = allStocks
            .filter { $0.pChange > 0 }
            .sorted { $0.pChange > $1.pChange }
    }
    
    func filterLooserStocks() {
        topLooserStocks = allStocks
            .filter { $0.pChange < 0 }
            .sorted { $0.pChange < $1.pChange }
    }

    // MARK: - Portfolio Management

    func fetchPortfolioStocks() async {
        guard let user = self.authViewModel.user else {
            print("❌ User not available, cannot fetch portfolio stocks.")
            return
        }
        
        do {
            let dbPortfolioStocks = try await userManager.getUserPortfolio(userID: user.userID)
            self.portfolioStocks = dbPortfolioStocks
            print("✅ Portfolio stocks fetched and added to array.")
            
            // ✅ CRITICAL: Call the summary calculation here
            await calculatePortfolioSummary()
            
        } catch {
            print("❌ Failed to fetch portfolio stocks: \(error.localizedDescription)")
            self.portfolioStocks = []
        }
    }
    
    private func calculatePortfolioSummary() async {
        guard !portfolioStocks.isEmpty else {
            self.totalInvestment = 0
            self.portfolioValue = 0
            self.totalGainLoss = 0
            return
        }
        
        var calculatedTotalInvestment: Double = 0.0
        var calculatedPortfolioValue: Double = 0.0

        for portfolioStock in portfolioStocks {
            
            // Get the current stock data from the main list of all stocks
            // This assumes that `allStocks` is already populated.
            guard let currentStockData = allStocks.first(where: { $0.symbol == portfolioStock.stockSymbol }) else {
                print("❌ Stock data not found for symbol: \(portfolioStock.stockSymbol)")
                continue
            }
            
            let investment = Double(portfolioStock.quantity) * portfolioStock.avgBuyPrice
            calculatedTotalInvestment += investment

            let currentPrice = currentStockData.lastPrice
            let currentValue = Double(portfolioStock.quantity) * currentPrice
            calculatedPortfolioValue += currentValue
        }

        self.totalInvestment = calculatedTotalInvestment
        self.portfolioValue = calculatedPortfolioValue
        self.totalGainLoss = self.portfolioValue - self.totalInvestment
    }
    
    // MARK: - Firestore Cache
    
    func uploadStocks(_ stocks: [StockModel]) async {
        // ... (Your existing function)
        let db = Firestore.firestore()
        for stock in stocks {
            do {
                try await db.collection("stocksCache").document(stock.symbol).setData(from: stock, merge: false)
                print("Uploaded \(stock.symbol)")
            } catch {
                print("Failed to upload \(stock.symbol): \(error)")
            }
        }
    }
    
    func fetchStocksFromFirestore() async -> [StockModel] {
        // ... (Your existing function)
        let db = Firestore.firestore()
        do {
            let snapshot = try await db.collection("stocksCache").getDocuments()
            let stocks = snapshot.documents.compactMap { doc -> StockModel? in
                try? doc.data(as: StockModel.self)
            }
            return stocks
        } catch {
            print("Failed to load from Firestore: \(error)")
            return []
        }
    }
    
    // MARK: - Utility Functions

    func returnStockModel(symbol: String) -> StockModel? {
        return allStocks.first { $0.symbol == symbol }
    }
}
