import SwiftUI
struct StatisticsView: View {
    let nifty50: StockModel?

    let staticStats: [StatisticsModel] = [
        StatisticsModel(title: "SENSEX", value: "81,757", percentChange: -0.61),
        StatisticsModel(title: "NASDAQ", value: "20,895", percentChange: 0.048),
        StatisticsModel(title: "GOLD", value: "1,01,295", percentChange: -1.5),
        StatisticsModel(title: "SILVER", value: "1,11,000", percentChange: 2.5)
    ]

    var body: some View {
        NavigationStack {
           
                VStack(alignment: .leading, spacing: 0) {

                    // MARK: - Horizontal Scrollable Stats
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            if let stock = nifty50 {
                                NavigationLink(destination: DetailView(stock: nifty50, DBStock: nil)) {
                                    StatCardView(stat: StatisticsModel(
                                        title: stock.symbol ,
                                        value: stock.lastPrice.asFormattedString(),
                                        percentChange: stock.pChange
                                    ))
                                }
                            }




                            ForEach(staticStats) { stat in
                                StatCardView(stat: stat)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 4) // Reduce bottom padding here
                    }

                    // You can add more sections below...
            }
        }
    }
}

struct StatCardView: View {
    let stat: StatisticsModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondary)

            Text("₹" + stat.value)
                .font(.headline)
                .bold()
                .foregroundStyle(Color.theme.accent)

            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(.degrees(stat.percentChange >= 0 ? 0 : 180))
                Text(stat.percentChange.asPercentString())
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(stat.percentChange >= 0 ? Color.theme.green : Color.theme.red)
        }
        
        .padding()
        .frame(width: 140, height: 80, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.background.opacity(0.15))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
    }
}


extension Double {
    func asFormattedString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}


#Preview {
    StatisticsView(nifty50: DeveloperPreview.instance.stock)
}
