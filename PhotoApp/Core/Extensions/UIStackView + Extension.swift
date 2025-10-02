//
//  UIStackView + Extension.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 23.05.2025.
//

import UIKit

extension UIStackView {
    static func create(
        axis: NSLayoutConstraint.Axis,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat
    ) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.distribution = .fill
        stack.alignment = alignment
        stack.spacing = spacing
        return stack
    }
    
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            addArrangedSubview(subview)
        }
    }
}
