import Foundation
class StockDataService {
    static let shared = StockDataService()
    private init() {}
    
    func fetchStocks() async -> [StockModel] {
        let url = "https://www.nseindia.com/api/equity-stockIndices?index=NIFTY%2050"
        let headers = [
                  "Accept": "*/*",
                  "Accept-Encoding": "gzip, deflate, br",
                  "Accept-Language": "en-US,en;q=0.9",
                  "Connection": "keep-alive",
                  "Host": "www.nseindia.com",
                  "Origin": "https://www.nseindia.com",
                  "Referer": "https://www.nseindia.com/market-data/live-equity-market",
                  "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
              ]


        do {
            let response: NiftyResponse = try await NetworkManager.shared.fetch(
                urlString: url,
                headers: headers,
                responseType: NiftyResponse.self
            )
            return response.data
        } catch {
            print("❌ Failed to fetch stocks: \(error)")
            return []
        }
    }
}
