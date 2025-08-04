import SwiftUI
import Charts
struct StockChartView: View {
    let symbol: String
    @StateObject private var vm = StockChartViewModel()
    @State private var scale: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        VStack(spacing: 0) {
            if vm.isLoading {
                ProgressView("Loading...").padding()
            } else if vm.historicData.isEmpty {
                Text("No chart data available.").padding()
            } else {
                ZoomableChartView(
                    data: vm.historicData,
                    isStockUp: vm.isStockUp,
                    scale: $scale,
                    dragOffset: $dragOffset
                )
                .frame(height: 250)
                .padding(.horizontal)
            }

            Picker("Range", selection: $vm.selectedRange) {
                ForEach(ChartRange.allCases) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 8)
        }
    
        .navigationTitle("\(symbol.uppercased()) Chart")
        .task {
            await vm.fetchChart(for: symbol)
        }
    }
}


#Preview {
    StockChartView(symbol: "TCS.NS")
}
