//
//  UIStackView + Extension.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 23.05.2025.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            addArrangedSubview(subview)
        }
    }
}
