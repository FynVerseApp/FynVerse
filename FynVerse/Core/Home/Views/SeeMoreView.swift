import SwiftUI

struct SeeMoreView: View {
    let resultantStocks: [StockModel]
    let title: String // This is the new property for reusability
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(resultantStocks) { stock in
                    // NavigationLink is now part of the content, which is correct
                    NavigationLink(value: stock) {
                        // Pass nil for portfolioStock as this is a general list
                        StockRowView(stock: stock, portfolioStock: nil)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle(title) // Use the new title property
    }
}

#Preview {
    NavigationStack {
        // You can now create a preview for any kind of stock list
        SeeMoreView(
            resultantStocks: [
                DeveloperPreview.instance.stock,
                DeveloperPreview.instance.stock,
                DeveloperPreview.instance.stock,
                DeveloperPreview.instance.stock
            ],
            title: "Top Gainers" // Example of a reusable title
        )
        .navigationDestination(for: StockModel.self) { stock in
            // Your detail view
            Text(stock.symbol)
        }
    }
}
