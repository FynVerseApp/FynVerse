import Foundation


/*
 {"name":"NIFTY 50","advance":{"declines":"22","advances":"26","unchanged":"2"},"timestamp":"17-Jul-2025 14:00:30","data":[{"priority":1,"symbol":"NIFTY 50","identifier":"NIFTY 50","open":25230.75,"dayHigh":25238.35,"dayLow":25144,"lastPrice":25179.65,"previousClose":25212.05,"change":-32.39999999999782,"pChange":-0.13,"ffmc":1137911063.02,"yearHigh":26277.35,"yearLow":21743.65,"totalTradedVolume":160150301,"stockIndClosePrice":0,"totalTradedValue":158899932335.66,"lastUpdateTime":"17-Jul-2025 14:00:30","nearWKH":4.177361872487131,"nearWKL":-15.802314698774124,"perChange365d":2.43,"date365dAgo":"16-Jul-2024","chart365dPath":"https://nsearchives.nseindia.com/365d/NIFTY-50.svg","date30dAgo":"16-Jun-2025","perChange30d":1.06,"chart30dPath":"https://nsearchives.nseindia.com/30d/NIFTY-50.svg","chartTodayPath":"https://nsearchives.nseindia.com/today/NIFTY-50.svg"}
 
 
 let baseURL = "https://www.nseindia.com"
 let fullChartURL = baseURL + chart365DPath
 fullChartUrl =https://www.nseindia.comhttps://nsearchives.nseindia.com/365d/NIFTY-50.svg
 
 */

struct NiftyResponse: Codable {
    let name: String
    let advance: Advance
    let timestamp: String
    let data: [StockModel]
}

struct Advance: Codable {
    let declines: String
    let advances: String
    let unchanged: String
}

struct NSEStockResponse: Codable {
    let data: [StockModel]
}
import Foundation

struct StockModel: Codable, Identifiable, Hashable {
    var id: String { symbol }

    let priority: Int
    let symbol, identifier: String
    let open: Double
    let dayHigh: Double
    let dayLow: Double
    let lastPrice: Double
    let previousClose: Double
    let change: Double
    let pChange: Double
    let ffmc: Double?
    let yearHigh: Double
    let yearLow: Double
    let totalTradedVolume: Int
    let stockIndClosePrice: Double
    let totalTradedValue: Double
    let lastUpdateTime: String?
    let nearWKH: Double?
    let nearWKL: Double?
    let perChange365D: Double?
    let date365DAgo: String?
    let chart365DPath: String?
    let date30DAgo: String?
    let perChange30D: Double?
    let chart30DPath: String?
    let chartTodayPath: String?

    enum CodingKeys: String, CodingKey {
        case priority, symbol, identifier
        case open, dayHigh, dayLow, lastPrice, previousClose, change, pChange
        case ffmc, yearHigh, yearLow, totalTradedVolume, stockIndClosePrice, totalTradedValue
        case lastUpdateTime, nearWKH, nearWKL, perChange365D
        case date365DAgo = "date365dAgo"
        case chart365DPath = "chart365dPath"
        case date30DAgo = "date30dAgo"
        case perChange30D = "perChange30d"
        case chart30DPath = "chart30dPath"
        case chartTodayPath

    }
}
