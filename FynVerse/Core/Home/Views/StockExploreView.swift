import SwiftUI
import SwiftUI

struct StockExploreView: View {
    let stock: StockModel
    // Removed @State private var selectedStock: StockModel? = nil

    var body: some View {
        VStack(spacing: 6) {
            // Symbol with logo
            HStack(spacing: 8) {
                StockImageView(stock: stock)
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())

                Text(stock.symbol)
                    .font(.callout)
                    .bold()
                    .foregroundStyle(Color.theme.accent)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            // Price
            Text(stock.lastPrice.asCurrencywith6Decimals())
                .font(.callout)
                .bold()
                .foregroundStyle(Color.theme.secondary)

            // Change %
            Text(stock.pChange.asPercentString())
                .font(.callout)
                .foregroundStyle(stock.pChange >= 0 ? Color.theme.green : Color.theme.red)
        }
        // Removed .onTapGesture
        // Removed .navigationDestination
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .frame(height: 100)
        .background(.ultraThinMaterial.opacity(0.3))
    }
}
#Preview {
    NavigationStack{
        StockExploreView(stock: DeveloperPreview.instance.stock)
    }
}
