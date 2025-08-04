//
//  ZoomableChartView.swift
//  FynVerse
//
//  Created by zubair ahmed on 28/07/25.
//

import SwiftUI
import Charts
struct ZoomableChartView: View {
    let data: [HistoricPriceModel]
    let isStockUp: Bool

    @Binding var scale: CGFloat
    @Binding var dragOffset: CGSize

    private var priceRange: ClosedRange<Double> {
        let prices = data.map { $0.close }
        let minPrice = prices.min() ?? 0
        let maxPrice = prices.max() ?? 1
        let padding = (maxPrice - minPrice) * 0.1
        return (minPrice - padding)...(maxPrice + padding)
    }

    var body: some View {
        GeometryReader { _ in
            ChartViewContent(data: data, isStockUp: isStockUp, yRange: priceRange)
                .scaleEffect(scale)
                .offset(dragOffset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = max(1.0, min(value, 3.0))
                        }
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { _ in
                            withAnimation {
                                dragOffset = .zero
                            }
                        }
                )
        }
    }
}
