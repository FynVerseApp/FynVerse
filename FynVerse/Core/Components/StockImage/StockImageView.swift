//
//  StockImageView.swift
//  FynVerse
//
//  Created by zubair ahmed on 18/07/25.
//

import SwiftUI
import Foundation
struct StockImageView: View {
    let stock:StockModel
    @StateObject  var viewModel:StockImageViewModel
    init(stock: StockModel) {
            self.stock = stock
            _viewModel = StateObject(wrappedValue: StockImageViewModel(stock: stock))
        }
    var body: some View {
        ZStack{
            if let image = viewModel.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            else if viewModel.isLoading{
                ProgressView()
            }
            else{
                Image(systemName: "indianrupeesign.ring.dashed")
                    .foregroundStyle(Color.theme.secondary)
            }
        } .onAppear {
            Task {
                await viewModel.getStockImage()
            }
        }
    }
}

#Preview {
    StockImageView(stock: DeveloperPreview.instance.stock)
        .padding()
       
}
