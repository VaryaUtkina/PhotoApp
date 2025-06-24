//
//  StackFactory.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 24.06.2025.
//

import UIKit

enum StackStyle {
    case vertical(spacing: CGFloat, alignment: UIStackView.Alignment)
    case horizontal(spacing: CGFloat, alignment: UIStackView.Alignment)
}

final class StackFactory {
    static func makeStack(style: StackStyle) -> UIStackView {
        let stack = UIStackView()
        
        switch style {
        case .vertical(let spacing, let alignment):
            stack.axis = .vertical
            stack.spacing = spacing
            stack.alignment = alignment
        case .horizontal(let spacing, let alignment):
            stack.axis = .horizontal
            stack.spacing = spacing
            stack.alignment = alignment
        }
        
        stack.distribution = .fill
        return stack
    }
}
