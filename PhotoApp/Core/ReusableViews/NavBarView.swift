//
//  NavBarView.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 06.10.2025.
//

import UIKit
import SnapKit

final class NavBarView: UIView {
    
    private enum Drawing {
        static var cornerRadius: CGFloat { 40 }
        static var horizontalInset: CGFloat { 20 }
        static var bottomInset: CGFloat { 16 }
        
        static var backButtonSize: CGSize { CGSize(width: 24, height: 24) }
    }
    
    // MARK: - UI Elements
    private let shadowView: UIView = {
        let sView = UIView()
        sView.backgroundColor = .clear
        sView.layer.shadowColor = UIColor.black.cgColor
        sView.layer.shadowOpacity = 0.15
        sView.layer.shadowOffset = CGSize(width: 0, height: 4)
        sView.layer.shadowRadius = 8
        sView.layer.masksToBounds = false
        sView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        sView.layer.cornerRadius = Drawing.cornerRadius
        return sView
    }()
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        blurView.layer.cornerRadius = Drawing.cornerRadius
        blurView.layer.masksToBounds = true
        return blurView
    }()
    private let titleLabel = LabelBuilder()
        .setFont(.systemFont(ofSize: 20, weight: .semibold))
        .setColor(.systemPink.withAlphaComponent(0.8))
        .build()
    private let backButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        config.image = UIImage(
            systemName: "arrowshape.turn.up.backward.2.fill",
            withConfiguration: symbolConfig
        )?.withRenderingMode(.alwaysTemplate)
        config.baseForegroundColor = .systemPink.withAlphaComponent(0.8)
        button.configuration = config
        return button
    }()

    // MARK: - Public Properties
    let height: CGFloat = 115
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func showBackButton(_ isShowing: Bool) {
        backButton.isHidden = !isShowing
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        Log.debug("backButtonTapped", logger: Log.ui)
    }
}

// MARK: - Setup UI
private extension NavBarView {
    func setupUI() {
        backgroundColor = .clear
        addSubviews(shadowView, backButton)
        shadowView.addSubview(blurView)
        blurView.contentView.addSubviews(titleLabel)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Drawing.bottomInset)
        }
        backButton.snp.makeConstraints { make in
            make.size.equalTo(Drawing.backButtonSize)
            make.leading.equalToSuperview().inset(Drawing.horizontalInset)
            make.bottom.equalToSuperview().inset(Drawing.bottomInset)
        }
    }
}
