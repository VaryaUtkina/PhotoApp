//
//  MoodTabBarController.swift
//  MoodTracker
//
//  Created by Варвара Уткина on 29.09.2025.
//

import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {
    
    private struct Drawing {
        static var height: CGFloat { 65 }
        
        static var tabBarInsets: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: 20, bottom: 8, right: 20)
        }
    }
    
    // MARK: - UI Elements
    private let mainTabBar = MainTabBar(itemsData: [
        (icon: "photo.on.rectangle.angled", title: "Photos"),
        (icon: "star.fill", title: "Saved"),
        (icon: "figure.wave", title: "Profile")
    ])
    
    // MARK: - Private Properties
    private var customViewControllers: [UIViewController] = []
    private var currentIndex = 0
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildControllers()
        setupTabBar()
        customViewControllers[currentIndex].view.isHidden = false
    }

    // MARK: - Private Methods
    private func addChildControllers() {
        let vc1 = UINavigationController(rootViewController: TempVC())
        
        let markVC = TempVC()
        markVC.view.backgroundColor = .blue.withAlphaComponent(0.5)
        let vc2 = UINavigationController(rootViewController: markVC)
        
        let personVC = TempVC()
        personVC.view.backgroundColor = .yellow.withAlphaComponent(0.8)
        let vc3 = UINavigationController(rootViewController: personVC)
        
        customViewControllers = [vc1, vc2, vc3]
        
        customViewControllers.forEach { viewController in
            addChild(viewController)
            viewController.view.frame = view.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(viewController.view)
            viewController.didMove(toParent: self)
            viewController.view.isHidden = true
        }
    }
}

// MARK: - Setup UI
private extension MainTabBarController {
    func setupTabBar() {
        view.addSubview(mainTabBar)
        
        mainTabBar.snp.makeConstraints { make in
            make.height.equalTo(Drawing.height)
            make.horizontalEdges.equalToSuperview().inset(Drawing.tabBarInsets)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Drawing.tabBarInsets)
            
        }
        
        mainTabBar.onItemSelected = { [weak self] index in
            self?.selectViewController(at: index)
        }
    }
    
    func selectViewController(at index: Int) {
        guard index != currentIndex, index < customViewControllers.count else { return }
        
        customViewControllers[currentIndex].view.isHidden = true
        customViewControllers[index].view.isHidden = false
        currentIndex = index
    }
}
