//
//  ChartViewContent.swift
//  FynVerse
//
//  Created by zubair ahmed on 28/07/25.
//

import SwiftUI
import Charts

struct ChartViewContent: View {
    let data: [HistoricPriceModel]
    let isStockUp: Bool
    let yRange: ClosedRange<Double>

    var body: some View {
        Chart {
            ForEach(data, id: \.date) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Close", item.close)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(isStockUp ? Color.theme.green : Color.theme.red)
                .lineStyle(.init(lineWidth: 2))

                AreaMark(
                    x: .value("Date", item.date),
                    y: .value("Close", item.close)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            (isStockUp ? Color.theme.green : Color.theme.red).opacity(0.2),
                            .clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .chartYScale(domain: yRange)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4)) {
                AxisGridLine().foregroundStyle(.clear)
                AxisTick().foregroundStyle(.gray)
                AxisValueLabel(format: .dateTime.month(.abbreviated))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 5)) { value in
                AxisGridLine().foregroundStyle(.gray.opacity(0.1))
                AxisTick().foregroundStyle(.gray)

                AxisValueLabel(centered: false) {
                    if let doubleValue = value.as(Double.self) {
                        Text("₹\(Int(doubleValue))")
                    }
                }
            }
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(Color.white)
                .clipShape(Rectangle()) // ensures area mark doesn't bleed outside
                .border(Color.gray.opacity(0.2), width: 0.5)
        }
    }
}
