import SwiftUI

struct StockRowView: View {
    let stock: StockModel
    let portfolioStock: DBPortfolioStock?

    // MARK: - Computed Properties for PnL
    var currentHoldingValue: Double {
        guard let portfolio = portfolioStock else { return 0 }
        return stock.lastPrice * Double(portfolio.quantity)
    }
    
    var totalInvestment: Double {
        guard let portfolio = portfolioStock else { return 0 }
        return portfolio.avgBuyPrice * Double(portfolio.quantity)
    }

    var gainLoss: Double {
        return currentHoldingValue - totalInvestment
    }

    var gainLossPercentage: Double {
        guard totalInvestment != 0 else { return 0 }
        return (gainLoss / totalInvestment) * 100
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // MARK: - Stock Icon
                StockImageView(stock: stock)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.vertical, 8)
                
                // MARK: - Stock Info (Symbol and Name)
                VStack(alignment: .leading, spacing: 4) {
                    Text(stock.symbol)
                        .font(.headline)
                        .foregroundStyle(Color.theme.accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Text(stock.identifier)
                        .font(.footnote)
                        .foregroundStyle(Color.theme.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                
                Spacer()
                
                // MARK: - Market Price and Change
                VStack(alignment: .trailing, spacing: 4) {
                    Text(stock.lastPrice.asCurrencyWith2Decimals())
                        .font(.headline)
                        .bold()
                        .foregroundStyle(Color.theme.accent)
                    
                    Text(stock.pChange.asPercentString())
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(stock.pChange >= 0 ? Color.theme.green : Color.theme.red)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            // MARK: - Portfolio-specific Details
            if let portfolio = portfolioStock {
                Divider()
                    .padding(.horizontal)
                
                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
                    GridRow {
                        Text("Holdings:")
                            .gridColumnAlignment(.leading)
                            .font(.caption)
                            .foregroundStyle(Color.theme.secondary)
                        
                        Text("\(portfolio.quantity)")
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(Color.theme.accent)
                        
                        Text("Gain/Loss:")
                            .gridColumnAlignment(.leading)
                            .font(.caption)
                            .foregroundStyle(Color.theme.secondary)
                        
                        // Display PnL with dynamic color
                        Text("\(gainLoss.asCurrencyWith2Decimals()) (\(gainLossPercentage.asPercentString()))")
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(gainLoss >= 0 ? Color.theme.green : Color.theme.red)
                    }
                    GridRow {
                        Text("Avg. Price:")
                            .gridColumnAlignment(.leading)
                            .font(.caption)
                            .foregroundStyle(Color.theme.secondary)
                        
                        Text(portfolio.avgBuyPrice.asCurrencyWith2Decimals())
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(Color.theme.accent)
                            
                        Text("Total:")
                            .gridColumnAlignment(.leading)
                            .font(.caption)
                            .foregroundStyle(Color.theme.secondary)
                        
                        Text(currentHoldingValue.asCurrencyWith2Decimals())
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(Color.theme.accent)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(Color.theme.background)
        .cornerRadius(12)
        .shadow(color: Color.theme.accent.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
}
