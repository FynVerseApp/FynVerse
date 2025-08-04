//
//  Color.swift
//  FynVerse
//
//  Created by zubair ahmed on 15/07/25.
//

import Foundation
import SwiftUI


struct ColorTheme {
    // Brand & Accent Colors
    let accent = Color("AccentColor") // Brand-specific accent color; keep asset name
    let green = Color("GreeenColor")   // Use correct spelling and standard color asset
    let red = Color("ReedColor")       // Same as above
    let secondary = Color("SecondaryTextColor") // For secondary text elements

    // Background gradients with subtle, cool tones for a formal trading app look
    let background =                 LinearGradient(
        colors: [ Color(red: 127/255, green: 255/255, blue: 212/255), .teal.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Card background: darker and desaturated gradient to visually separate cards
    let cardBackground = LinearGradient(
            colors: [
                Color(hue: 0.60, saturation: 0.22, brightness: 0.14), // Darker slate blue-gray for depth
                Color(hue: 0.60, saturation: 0.12, brightness: 0.18)  // Slightly lighter for subtle contrast
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
}

extension Color{
    static let theme = ColorTheme()
}
