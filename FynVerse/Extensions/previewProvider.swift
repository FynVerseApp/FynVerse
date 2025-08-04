//
//  previewProvider.swift
//  FynVerse
//
//  Created by zubair ahmed on 17/07/25.
//
import SwiftUI

extension PreviewProvider{
    static var dev:DeveloperPreview {
        return DeveloperPreview.instance
    }
}
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

class DeveloperPreview{
    static let instance = DeveloperPreview()
    
    private init(){
        
    }
    
    let stat1 = [
        StatisticsModel(title: "SENSEX", value: "81,757", percentChange: -0.61),
        StatisticsModel(title: "NASDAQ", value: "20,895", percentChange: 0.048),
        StatisticsModel(title: "GOLD", value: "1,01,295", percentChange: -1.5),
        StatisticsModel(title: "SILVER", value: "1,11,000", percentChange: 2.5)
    ]
    let stock = StockModel(
        priority: 1,
        symbol: "NIFTY 50",
        identifier: "NIFTY 50",
        open: 25230.75,
        dayHigh: 25238.35,
        dayLow: 25144.0,
        lastPrice: 25179.65,
        previousClose: 25212.05,
        change: -32.40,
        pChange: -0.13,
        ffmc: 1137911063.02,
        yearHigh: 26277.35,
        yearLow: 21743.65,
        totalTradedVolume: 160150301,
        stockIndClosePrice: 0.0,
        totalTradedValue: 158899932335.66,
        lastUpdateTime: "17-Jul-2025 14:00:30",
        nearWKH: 4.177361872487131,
        nearWKL: -15.802314698774124,
        perChange365D: 2.43,
        date365DAgo: "16-Jul-2024",
        chart365DPath: "https://nsearchives.nseindia.com/365d/NIFTY-50.svg",
        date30DAgo: "16-Jun-2025",
        perChange30D: 1.06,
        chart30DPath: "https://nsearchives.nseindia.com/30d/NIFTY-50.svg",
        chartTodayPath: "https://nsearchives.nseindia.com/today/NIFTY-50.svg",
    )
}
