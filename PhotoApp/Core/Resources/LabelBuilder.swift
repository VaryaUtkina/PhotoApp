//
//  LabelBuilder.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 24.06.2025.
//

import UIKit

final class LabelBuilder {
    private var textColor: UIColor = .black
    private var font: UIFont = .systemFont(ofSize: 12, weight: .semibold)
    private var numberOfLines: Int = 1
    private var isUserInteractionEnabled: Bool = false
    
    func setColor(_ color: UIColor) -> Self {
        textColor = color
        return self
    }
    
    func setFont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    func setNumberOfLines(_ numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    
    func setUserInteractionEnabled(_ enabled: Bool) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }
    
    func build() -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = font
        label.numberOfLines = numberOfLines
        label.isUserInteractionEnabled = isUserInteractionEnabled
        return label
    }
}
