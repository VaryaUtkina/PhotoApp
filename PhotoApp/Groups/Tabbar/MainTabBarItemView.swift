//
//  MainTabBarItemView.swift
//  MoodTracker
//
//  Created by Варвара Уткина on 29.09.2025.
//

import UIKit
import SnapKit

final class MainTabBarItemView: UIView {
    
    private enum Drawing {
        static var height: CGFloat { 50 }
        static var iconSize: CGSize { CGSize(width: 30, height: 30) }
    }
    
    // MARK: - UI Elements
    let iconView = UIImageView()
    let titleLabel = UILabel()
    
    // MARK: - Private Properties
    private let icon: String
    private let title: String
    
    // MARK: - Initializers
    init(icon: String, title: String) {
        self.icon = icon
        self.title = title
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func updateUIFor(isSelected: Bool) {
        iconView.tintColor = isSelected
        ? .systemPink.withAlphaComponent(0.8)
        : .gray
        
        titleLabel.textColor = isSelected
        ? .systemPink.withAlphaComponent(0.8)
        : .gray
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubviews(iconView, titleLabel)
        
        iconView.image = UIImage(systemName: icon)?.withRenderingMode(.alwaysTemplate)
        iconView.contentMode = .scaleAspectFit
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        
        snp.makeConstraints { make in
            make.height.equalTo(Drawing.height)
        }
        iconView.snp.makeConstraints { make in
            make.size.equalTo(Drawing.iconSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(2)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom).offset(2)
        }
    }
}
