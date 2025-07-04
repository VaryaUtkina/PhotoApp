//
//  SceneDelegate.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 19.05.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let sceneWindow = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: sceneWindow)
        
        let photosVC = PhotosViewController()
        let presenter = PhotosPresenter(view: photosVC, networkManager: NetworkManager.shared)
        photosVC.presenter = presenter
        window?.rootViewController = UINavigationController(rootViewController: photosVC)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

