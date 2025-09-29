//
//  MainTabBar.swift
//  MoodTracker
//
//  Created by Варвара Уткина on 29.09.2025.
//

import UIKit
import SnapKit

final class MainTabBar: UIView {
    
    private enum Drawing {
        static var cornerRadius: CGFloat { 30 }
        static var spacing: CGFloat { 36 }
        static var inset: CGFloat { 26 }
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
        sView.layer.cornerRadius = Drawing.cornerRadius
        return sView
    }()
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = Drawing.cornerRadius
        blurView.layer.masksToBounds = true
        return blurView
    }()
    private let tabBarStack = UIStackView.create(
        axis: .horizontal,
        alignment: .center,
        spacing: Drawing.spacing
    )
    
    // MARK: - Public Properties
    var items: [MainTabBarItemView] = []
    var onItemSelected: ((Int) -> Void)?
    
    // MARK: - Private Properties
    private var selectedIndex: Int = 0
    private let itemsData: [(icon: String, title: String)]
    
    // MARK: - Initializers
    init(itemsData: [(icon: String, title: String)]) {
        self.itemsData = itemsData
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc func itemTapped(_ sender: UITapGestureRecognizer) {
        if let view = sender.view {
            selectedIndex = view.tag
            updateSelection()
            onItemSelected?(selectedIndex)
        }
    }
    
    // MARK: - Private Methods
    private func updateSelection() {
        for (index, item) in items.enumerated() {
            item.updateUIFor(isSelected: index == selectedIndex)
        }
    }
}

// MARK: - Setup UI
private extension MainTabBar {
    func setupUI() {
        backgroundColor = .clear
        addSubview(shadowView)
        shadowView.addSubview(blurView)
        blurView.contentView.addSubview(tabBarStack)
        tabBarStack.distribution = .fillEqually
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tabBarStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Drawing.inset)
            make.top.equalToSuperview().inset(7.5)
        }
        
        for (index, data) in itemsData.enumerated() {
            let itemView = MainTabBarItemView(
                icon: data.icon,
                title: data.title
            )
            itemView.tag = index
            let tap = UITapGestureRecognizer(target: self, action: #selector(itemTapped(_:)))
            itemView.addGestureRecognizer(tap)
            tabBarStack.addArrangedSubview(itemView)
            items.append(itemView)
        }
        
        updateSelection()
    }
}

