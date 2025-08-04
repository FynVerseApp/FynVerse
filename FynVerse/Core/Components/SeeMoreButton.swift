//
//  SeeMoreButton.swift
//  FynVerse
//
//  Created by zubair ahmed on 19/07/25.
//

import SwiftUI

struct SeeMoreButton: View {
    let resultantStocks: [StockModel]
    
    var body: some View {
        // Push the entire array of stocks as a value
        NavigationLink(value: resultantStocks) {
            Text("See More")
                .font(.subheadline)
                .bold()
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        SeeMoreButton(resultantStocks: [
            DeveloperPreview.instance.stock,
            DeveloperPreview.instance.stock,
            DeveloperPreview.instance.stock
        ])
    }
}
