//
//  PhotosPresenter.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 18.06.2025.
//

import UIKit

// MARK: - PhotosPresenter
final class PhotosPresenter {
    
    // MARK: - Dependencies
    var view: PhotosViewController
    let networkManager: NetworkManager
    
    // MARK: - Public Properties
    var numberOfPhotos: Int {
        photoInfos.count
    }
    
    // MARK: - Private Properties
    private let searchQuery = "nature"
    private var photoInfos: [UnsplashPhoto] = []
    
    // MARK: - Initializers
    init(view: PhotosViewController, networkManager: NetworkManager) {
        self.view = view
        self.networkManager = networkManager
    }
    
    // MARK: - Public Methods
    func fetchPhotos() {
        networkManager.fetchPhotos(query:searchQuery) { [weak self] result in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    self?.photoInfos = results
                    self?.view.reloadPhotos()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchPhoto(for indexPath: IndexPath, completion: @escaping ((UIImage) -> Void)) {
        guard photoInfos.indices.contains(indexPath.item) else {
            assertionFailure()
            return
        }
        let photoInfo = photoInfos[indexPath.item]
        
        networkManager.fetchPhoto(from: photoInfo.urls.regular) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    completion(image)
                case .failure(_):
                    let errorImage = UIImage(systemName: "photo.on.rectangle.angled")
                    completion(errorImage ?? UIImage())
                }
            }
        }
    }
    
    func getPhotoInfo(at indexPath: IndexPath) -> UnsplashPhoto? {
        guard photoInfos.indices.contains(indexPath.item) else {
            assertionFailure()
            return nil
        }
        return photoInfos[indexPath.item]
    }
}
