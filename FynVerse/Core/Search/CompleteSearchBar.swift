import SwiftUI

struct CompleteSearchBar: View {
    @Binding var searchText: String
    let filteredStock: [StockModel]
    
    @FocusState private var isTextFieldFocused: Bool
    // REMOVED: @State private var selectedStock: StockModel? = nil
    
    var body: some View {
        VStack {
            // Search Field with clear button
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.theme.secondary)
                
                TextField("Search by name or symbol...", text: $searchText)
                    .foregroundStyle(Color.theme.secondary)
                    .autocorrectionDisabled()
                    .focused($isTextFieldFocused)
                    .overlay(
                        Group {
                            if !searchText.isEmpty {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color.theme.accent)
                                    .padding(.trailing, 8)
                                    .onTapGesture {
                                        searchText = ""
                                    }
                            }
                        },
                        alignment: .trailing
                    )
            }
            .font(.headline)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.theme.accent)
                    .shadow(color: Color.green.opacity(0.15), radius: 10, x: 0, y: 0)
            )
            .padding(.horizontal)
            .onAppear {
                isTextFieldFocused = true
            }
            
            // Use a ScrollView with LazyVStack for a performant, custom list
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredStock) { stock in
                        // The NavigationLink pushes the stock onto the stack
                        NavigationLink(value: stock) {
                            StockRowView(stock: stock, portfolioStock: nil)
                                .transition(.opacity)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            // REMOVED: .navigationDestination modifier
        }
        .background(Color.theme.background.ignoresSafeArea())
    }
}

// Corrected Preview
#Preview {
    NavigationStack {
        PreviewWrapper()
    }
}

struct PreviewWrapper: View {
    @State private var searchText = ""
    @State private var filteredStock = [DeveloperPreview.instance.stock, DeveloperPreview.instance.stock, DeveloperPreview.instance.stock]
    
    var body: some View {
        // Here, we provide a NavigationDestination to make the links work in the preview
        CompleteSearchBar(searchText: $searchText, filteredStock: filteredStock)
            .navigationDestination(for: StockModel.self) { stock in
                DetailView(stock: stock, DBStock: nil)
            }
    }
}
