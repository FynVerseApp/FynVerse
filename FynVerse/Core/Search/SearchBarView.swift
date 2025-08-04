//
//  SearchBarView.swift
//  FynVerse
//
//  Created by zubair ahmed on 18/07/25.
//

import SwiftUI

struct SearchBarView: View {
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.theme.secondary)
                Text("Search by name or symbol...")
                    .foregroundStyle(Color.theme.accent.opacity(0.2))
                    .autocorrectionDisabled()
                
                Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.theme.accent)
                        .padding()
                        .offset(x:10)
            }
            .font(.headline)
            .padding()
            .background(RoundedRectangle(cornerRadius: 50)
                .fill(Color.theme.background)
                .shadow(color: Color.green.opacity(0.15), radius: 10, x: 0, y: 0)
            )
            .padding()
        }
    
    }
    
}

#Preview {
    SearchBarView()
}
