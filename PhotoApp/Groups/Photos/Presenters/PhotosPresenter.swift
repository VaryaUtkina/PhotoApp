//
//  PhotosPresenter.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 18.06.2025.
//

import UIKit

final class PhotosPresenter {
    
    // MARK: - Dependencies
    @WeakObj var view: PhotosViewController
    private let networkManager: NetworkManager
    private let router: Router
    
    // MARK: - Public Properties
    var numberOfPhotos: Int {
        photoInfos.count
    }
    
    // MARK: - Private Properties
    private let searchQuery = "nature"
    private var photoInfos: [UnsplashPhoto] = []
    
    // MARK: - Initializers
    init(
        networkManager: NetworkManager,
        router: Router
    ) {
        self.networkManager = networkManager
        self.router = router
    }
    
    // MARK: - Public Methods
    func fetchPhotos() {
        networkManager.fetchPhotos(query:searchQuery) { [weak self] result in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    self?.photoInfos = results
                    self?.view.reloadPhotos(results)
                }
            case .failure(let error):
                Log.error(error.localizedDescription, logger: Log.networking)
            }
        }
    }
    
    func fetchPhoto(for indexPath: IndexPath, completion: @escaping ((UIImage) -> Void)) {
        guard photoInfos.indices.contains(indexPath.item) else {
            assertionFailure()
            return
        }
        let photoInfo = photoInfos[indexPath.item]
        // TODO: - size of image for information
        Log.debug("width: \(photoInfo.width). height: \(photoInfo.height)", logger: Log.ui)

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
    
    func openPhotoInfo(at index: Int) {
        photoInfos.element(at: index).map { router.showDetail(for: $0) }
//        photoInfos.element(at: index).map { photoInfo in
//            let detailsVC = PhotoDetailsViewController()
//            let presenter = PhotoDetailsPresenter(view: detailsVC, networkManager: getNetworkManager(), photoInfo: photoInfo)
//            detailsVC.presenter = presenter
//            view.showDestination(detailsVC)
//        }
    }
    
    func getNetworkManager() -> NetworkManager {
        networkManager
    }
}

extension Array {
    func element(at index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    subscript(safe index: Int) -> Element? {
        element(at: index)
    }
}
