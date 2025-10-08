//
//  UICollectionViewFlowLayout + Extension.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 08.10.2025.
//

import UIKit

extension UICollectionViewFlowLayout {
    static func createLayout(
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        lineSpacing: CGFloat,
        interItemSpacing: CGFloat,
        itemSize: CGSize?
    ) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = interItemSpacing
        if let itemSize {
            layout.itemSize = itemSize
        }
        return layout
    }
}
