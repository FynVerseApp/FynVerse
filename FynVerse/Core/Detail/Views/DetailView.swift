import SwiftUI

struct DetailView: View {
    let stock: StockModel?
    let DBStock : DBPortfolioStock?
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var selectedTab = 0
    @State private var showMoreOverview = false
    @State private var showMoreDetails = false
    @State private var showBuySheet = false
    @State private var showSellSheet = false

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()

            ScrollView {
                VStack {
                    if let stock = stock {
                        StockChartView(symbol: stock.symbol)
                            .frame(height: 300)
                            .padding(.bottom, 10)
                    }

                    tabSelector
                    tabDetailView
                }
                .padding(.bottom, 100)
            }

            floatingBuySellView
        }
        .sheet(isPresented: $showBuySheet) {
            if let stock = stock {
                BuySellSheetView(stock: stock, isBuying: true)
                    .environmentObject(viewModel)
            }
        }
        .sheet(isPresented: $showSellSheet) {
            if let stock = stock {
                BuySellSheetView(stock: stock, isBuying: false)
                    .environmentObject(viewModel)
            }
        }
        .navigationTitle(stock?.symbol ?? "Stock")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let stock = stock {
                    HStack {
                        Text(stock.symbol)
                            .font(.headline)
                            .foregroundStyle(Color.theme.secondary)
                        StockImageView(stock: stock)
                            .frame(width: 25, height: 25)
                    }
                }
            }
        }
    }

    private var tabSelector: some View {
        HStack {
            Button(action: { selectedTab = 0 }) {
                Text("Details")
                    .fontWeight(selectedTab == 0 ? .bold : .regular)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(selectedTab == 0 ? Color.blue.opacity(0.1) : Color.clear)
                    .cornerRadius(8)
            }

            Button(action: { selectedTab = 1 }) {
                Text("About")
                    .fontWeight(selectedTab == 1 ? .bold : .regular)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(selectedTab == 1 ? Color.blue.opacity(0.1) : Color.clear)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    private var floatingBuySellView: some View {
        VStack {
            Spacer()
            HStack(spacing: 16) {
                Button(action: { showBuySheet = true }) {
                    Text("Buy")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }

                Button(action: { showSellSheet = true }) {
                    Text("Sell")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)
            .shadow(radius: 5)
        }
    }

    private var tabDetailView: some View {
        Group {
            if selectedTab == 0 {
                VStack(spacing: 20) {
                    if  let stock = stock{
                        StockRowView(stock: stock, portfolioStock: DBStock)
                    }
                    SectionHeader(title: "Overview")
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(overviewInfo().prefix(showMoreOverview ? .max : 4), id: \ .0) { item in
                            InfoCell(title: item.0, value: item.1)
                        }
                    }
                    .padding(.horizontal)

                    Button(showMoreOverview ? "Show less" : "Read more") {
                        withAnimation { showMoreOverview.toggle() }
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)

                    SectionHeader(title: "Additional Details")
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(additionalInfo().prefix(showMoreDetails ? .max : 4), id: \ .0) { item in
                            InfoCell(title: item.0, value: item.1)
                        }
                    }
                    .padding(.horizontal)

                    Button(showMoreDetails ? "Show less" : "Read more") {
                        withAnimation { showMoreDetails.toggle() }
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                .padding(.top)
            } else {
                if let symbol = stock?.symbol {
                    WikiDescriptionView(title: mapSymbolToCompany(symbol))
                        .padding()
                }
            }
        }
    }

    private func overviewInfo() -> [(String, String)] {
        return [
            ("Symbol", stock?.symbol ?? "-"),
            ("Last Price", stock?.lastPrice.asCurrencywith6Decimals() ?? "-"),
            ("Change %", stock?.pChange.asPercentString() ?? "-"),
            ("Total Volume", "\(stock?.totalTradedVolume ?? 0)"),
            ("Total Value", stock?.totalTradedValue.asNumberString() ?? "-"),
            ("Open", stock?.open.asCurrencywith6Decimals() ?? "-"),
            ("Day High", stock?.dayHigh.asCurrencywith6Decimals() ?? "-"),
            ("Day Low", stock?.dayLow.asCurrencywith6Decimals() ?? "-"),
            ("Previous Close", stock?.previousClose.asCurrencywith6Decimals() ?? "-"),
            ("Change", stock?.change.asCurrencywith6Decimals() ?? "-")
        ]
    }

    private func additionalInfo() -> [(String, String)] {
        return [
            ("FFMC", stock?.ffmc?.asNumberString() ?? "-"),
            ("Year High", stock?.yearHigh.asCurrencywith6Decimals() ?? "-"),
            ("Year Low", stock?.yearLow.asCurrencywith6Decimals() ?? "-"),
            ("Index Close", stock?.stockIndClosePrice.asCurrencywith6Decimals() ?? "-"),
            ("Last Updated", stock?.lastUpdateTime ?? "-"),
            ("Near 52W High", stock?.nearWKH?.asNumberString() ?? "-"),
            ("Near 52W Low", stock?.nearWKL?.asNumberString() ?? "-"),
            ("365D % Change", stock?.perChange365D?.asPercentString() ?? "-"),
            ("30D % Change", stock?.perChange30D?.asPercentString() ?? "-")
        ]
    }

    private func mapSymbolToCompany(_ symbol: String) -> String {
        // Mapping logic here...
        symbol.replacingOccurrences(of: ".NS", with: "")
    }
}

// MARK: - Components

struct InfoCell: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            Divider()
        }
    }
}


