//
//  Router.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 30.09.2025.
//

import UIKit
import SafariServices

@propertyWrapper
struct WeakObj<Obj: AnyObject> {
    weak var obj: Obj?
    
    var wrappedValue: Obj {
        get {
            guard let obj else {
                fatalError()
            }
            return obj
        }
        set { obj = newValue }
    }
    
}

// MARK: - AppFactory
final class AppFactory {
    
    func makePhotosVC(router: Router) -> UIViewController {
        let presenter = PhotosPresenter(networkManager: NetworkManager.shared, router: router)
        let photosVC = PhotosViewController(presenter: presenter)
        presenter.view = photosVC
        return photosVC
    }
    
    func makeTempVC(withColor color: UIColor) -> UIViewController {
        let tempVC = TempVC()
        tempVC.view.backgroundColor = color.withAlphaComponent(0.5)
        return tempVC
    }
    
    func makeSavedVC() -> UIViewController {
        let savedVC = SavedViewController()
        return savedVC
    }
}

final class Router {
    private let navigation: UINavigationController
    private let appFactory = AppFactory()
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    func showTabBar() {
        let photosVC = appFactory.makePhotosVC(router: self)
        let markVC = appFactory.makeSavedVC()
        let personVC = appFactory.makeTempVC(withColor: .yellow)
        
        let viewControllers = [photosVC, markVC, personVC]
        
        
        let tabBarVC = MainTabBarController(
            customViewControllers: viewControllers,
            router: self
        )
        navigation.pushViewController(tabBarVC, animated: false)
    }
    
    func showHomeView(animated: Bool = true) {
        let photosVC = appFactory.makePhotosVC(router: self)
        navigation.pushViewController(photosVC, animated: animated)
    }
    
    func showDetail(
        for photoInfo: UnsplashPhoto,
        networkManager: NetworkManager = .shared
    ) {
        let detailsVC = PhotoDetailsViewController()
        let presenter = PhotoDetailsPresenter(view: detailsVC, networkManager: networkManager, router: self, photoInfo: photoInfo)
        detailsVC.presenter = presenter
        navigation.pushViewController(detailsVC, animated: true)
        
    }
    
    func pop(animated: Bool = true) {
        navigation.popViewController(animated: animated)
    }
    
    func showSafari(withUrlString urlString: String, andVC vc: UIViewController) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        vc.present(safariVC, animated: true)
    }
}
