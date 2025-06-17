//
//  UIView + Extension.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 23.05.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }
}
