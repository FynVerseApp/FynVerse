import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
final class StockImageViewModel: ObservableObject {
    let stock: StockModel
    private let manager = ImageDataService.shared

    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var logoURL: String? = nil

    init(stock: StockModel) {
        self.stock = stock
    }

    func getStockImage() async {
        isLoading = true
        defer { isLoading = false }

        // Step 1: Try Fetching URL from Firestore Cache
        if let cachedURL = await fetchStockImageUrlFromFirestore(symbol: stock.symbol) {
            logoURL = cachedURL
            print("ℹ️ Using cached URL for \(stock.symbol): \(cachedURL)")
        } else {
            // Step 2: Fetch from API
            do {
                logoURL = try await manager.fetchFirstLogoImage(for: stock.symbol)
                if let fetchedURL = logoURL {
                    print("🌐 Fetched from API: \(fetchedURL)")
                    await uploadStocksImageUrl(fetchedURL)
                } else {
                    print("⚠️ API returned nil for \(stock.symbol)")
                    return
                }
            } catch {
                print("❌ API Error for \(stock.symbol): \(error.localizedDescription)")
                return
            }
        }

        // Step 3: Download Image from URL
        guard let validURL = logoURL else {
            print("❌ Invalid URL for \(stock.symbol)")
            return
        }

        do {
            image = try await manager.fetchImage(from: validURL)
            print("✅ Image Loaded for \(stock.symbol)")
        } catch {
            print("❌ Failed to download image for \(stock.symbol): \(error.localizedDescription)")
        }
    }

    func uploadStocksImageUrl(_ imageUrl: String) async {
        let db = Firestore.firestore()
        do {
            let data = ["url": imageUrl]
            try await db.collection("stocksImageCache")
                .document(stock.symbol)
                .setData(data, merge: false)
            print("✅ Uploaded image URL to Firestore for \(stock.symbol)")
        } catch {
            print("❌ Firestore Upload Error for \(stock.symbol): \(error.localizedDescription)")
        }
    }

    func fetchStockImageUrlFromFirestore(symbol: String) async -> String? {
        let db = Firestore.firestore()
        do {
            let document = try await db.collection("stocksImageCache").document(symbol).getDocument()
            if let data = document.data(),
               let url = data["url"] as? String {
                return url
            } else {
                print("⚠️ No URL found in Firestore for \(symbol)")
                return nil
            }
        } catch {
            print("❌ Firestore Fetch Error for \(symbol): \(error.localizedDescription)")
            return nil
        }
    }
}
