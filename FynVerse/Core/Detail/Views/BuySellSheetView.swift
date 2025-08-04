import SwiftUI

struct BuySellSheetView: View {
    let stock: StockModel?
    var isBuying: Bool
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var quantityText: String = "1"
    @FocusState private var isFocused: Bool
    @State private var showSuccessAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    

    private var quantity: Int {
        return Int(quantityText) ?? 0
    }

    private var totalAmount: Double {
        guard let stock = stock else { return 0 }
        return Double(quantity) * stock.lastPrice
    }

    private var buttonText: String {
        isLoading ? "Processing..." : (isBuying ? "Confirm Buy" : "Confirm Sell")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let stock = stock {
                Text(isBuying ? "Buy \(stock.symbol)" : "Sell \(stock.symbol)")
                    .font(.title2).bold()

                HStack {
                    Text("Current Price:")
                    Spacer()
                    Text("₹\(String(format: "%.2f", stock.lastPrice))")
                        .foregroundColor(.gray)
                }

                HStack {
                    Text("Quantity:")
                    Spacer()
                    TextField("Enter quantity", text: $quantityText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .focused($isFocused)
                }

                Divider()

                HStack {
                    Text("Total Amount:")
                    Spacer()
                    Text("₹\(String(format: "%.2f", totalAmount))")
                        .font(.title3).bold()
                }
                
                // Display the current user ID for debugging purposes
               
                
                Spacer()
                
                // MARK: - ACTION BUTTON
                Button(action: {
                    guard !isLoading else { return }
                    guard quantity > 0 else {
                        errorMessage = "Please enter a valid quantity."
                        showErrorAlert = true
                        return
                    }
                    
                    // Safely get the user ID from the view model
                    guard let userID = authViewModel.user?.userID else {
                        errorMessage = "User not authenticated."
                        showErrorAlert = true
                        return
                    }

                    // Start an asynchronous task to perform the database operation
                    Task {
                        isLoading = true
                        
                        do {
                            if isBuying {
                                try await UserManager.shared.performBuyTransaction(
                                    userID: userID,
                                    stockSymbol: stock.symbol,
                                    quantity: quantity,
                                    pricePerShare: stock.lastPrice
                                )
                            } else {
                                try await UserManager.shared.performSellTransaction(
                                    userID: userID,
                                    stockSymbol: stock.symbol,
                                    quantity: quantity,
                                    pricePerShare: stock.lastPrice
                                )
                            }
                            // On success, show the success alert.
                            showSuccessAlert = true
                            
                        } catch {
                            // On error, show an error alert.
                            errorMessage = error.localizedDescription
                            showErrorAlert = true
                        }
                        
                        // Always reset loading state after the task completes.
                        isLoading = false
                    }
                }) {
                    Text(buttonText)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            (isBuying ? Color.green : Color.red)
                                .opacity(quantity > 0 && !isLoading ? 1 : 0.5)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(quantity <= 0 || isLoading)
                .contentShape(Rectangle()) // Makes entire area tappable
            }
        }
        .padding()
        .presentationDetents([.medium, .large])
        .onAppear {
            // Focus on the text field when the view appears.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss() // Automatically close the sheet
            }
        } message: {
            Text(isBuying ? "Stock bought successfully!" : "Stock sold successfully!")
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}
