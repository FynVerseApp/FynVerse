
import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Portfolio Summary Card
                    if !vm.portfolioStocks.isEmpty {
                        PortfolioSummaryView()
                    } else {
                        Text("You have no stocks in your portfolio.")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    // MARK: - Your Holdings Section
                    if !vm.portfolioStocks.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Your Holdings")
                                .font(.title3.bold())
                                .padding(.horizontal)
                           
                            ForEach(vm.portfolioStocks, id: \.id) { dbStock in
                                
                                if let stockModel = vm.returnStockModel(symbol: dbStock.stockSymbol) {
                                    /*
                                     NavigationLink(value: stockModel) {
                                     StockRowView(stock: stockModel, portfolioStock: dbStock)
                                     }
                                     .buttonStyle(.plain)*/
                                    NavigationLink(destination: DetailView(stock: stockModel, DBStock: dbStock)) {
                                        StockRowView(stock: stockModel, portfolioStock: dbStock)
                                    }
                                }
                            
                            }
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Portfolio")
            .background(Color.theme.background)
            // ✅ CRITICAL: This modifier handles navigation to the DetailView
            //.navigationDestination(for: StockModel.self) { stock in
                //DetailView(stock: stock, DBStock: nil)}
        }
        .task {
            // Fetch all stock data first, then the user's portfolio.
            await vm.fetchStocks()
        }
    }
}
struct PortfolioSummaryView: View {
    @EnvironmentObject var vm: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) { // Increased spacing for a cleaner look
            // Current Value & Total Gain/Loss (Combined for better visual hierarchy)
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Value")
                        .font(.subheadline)
                        .foregroundColor(Color.theme.secondary)
                    
                    Text(vm.portfolioValue.asCurrencyWith2Decimals())
                        .font(.largeTitle.bold()) // Made the main value more prominent
                        .foregroundColor(Color.theme.accent)
                }

            }

            Divider()
                .background(Color(.separator)) // Using system separator color for better integration

            // Total Investment
            HStack{
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Investment")
                        .font(.caption)
                        .foregroundColor(Color.theme.secondary)
                    
                    Text(vm.totalInvestment.asCurrencyWith2Decimals())
                        .font(.subheadline.bold())
                        .foregroundColor(Color.theme.accent)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) { // Use HStack with alignment for better layout
                        Text("Gain/Loss:")
                            .font(.caption)
                            .foregroundStyle(Color.theme.secondary)
                            .padding()
                        // Display the gain/loss and percentage in a single, well-formatted Text view
                        if vm.totalInvestment != 0 {
                            let pnlPercentage = (vm.totalGainLoss / vm.totalInvestment) * 100
                            let gainLossText = vm.totalGainLoss.asCurrencyWith2Decimals()
                            let pnlString = String(format: "%.2f%%", pnlPercentage)
                            
                            Text("\(gainLossText)( \(pnlString))")
                                .font(.headline.bold())
                                .foregroundColor(vm.totalGainLoss >= 0 ? Color.theme.green : Color.theme.red)
                        } else {
                            Text(vm.totalGainLoss.asCurrencyWith2Decimals())
                                .font(.headline.bold())
                                .foregroundColor(vm.totalGainLoss >= 0 ? Color.theme.green : Color.theme.red)
                        }
                    }
                }
            }
        }
        .padding(20) // Increased padding
        .background(Color.theme.background)
        .cornerRadius(20) // More rounded corners
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5) // Softer, more pronounced shadow
        .padding(.horizontal)
    }
}
