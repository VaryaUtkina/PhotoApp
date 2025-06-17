//
//  Color.swift
//  AiPhotoApp
//
//  Created by Варвара Уткина on 21.04.2025.
//

import UIKit

enum Color {
    static let background = color(fromHex: "#EDE9E3")
}

// MARK: - Get UIColor from HEX
extension Color {
    static func color(fromHex hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: alpha)
    }
}
