//
//  PhotoDetailsPresenter.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 20.06.2025.
//

import Foundation

final class PhotoDetailsPresenter {
    
    // MARK: - Dependencies
    var view: PhotoDetailsViewController
    let photoInfo: UnsplashPhoto
    private let networkManager: NetworkManager
    
    // MARK: - Initializers
    init(view: PhotoDetailsViewController, networkManager: NetworkManager, photoInfo: UnsplashPhoto) {
        self.view = view
        self.networkManager = networkManager
        self.photoInfo = photoInfo
    }
    
    // MARK: - Public Methods
    func fetchPhoto() {
        networkManager.fetchPhoto(from: photoInfo.urls.full) { result in
            DispatchQueue.main.async { [weak self] in
                self?.view.stopActivityIndicator()
                switch result {
                case .success(let image):
                    self?.view.setImage(image)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
