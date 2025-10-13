//
//  PhotoCollectionDataSource.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 08.10.2025.
//

import UIKit

final class PhotoCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Dependencies
    private let presenter: PhotosPresenter
    
    // MARK: - Private Properties
    private var photos: [UnsplashPhoto] = []
    
    init(collectionView: UICollectionView, presenter: PhotosPresenter) {
        self.presenter = presenter
        super.init()
        collectionView.dataSource = self
        
        collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier
        )
    }
    
    func updatePhotos(_ photos: [UnsplashPhoto]) {
        self.photos = photos
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.startAnimating()
        presenter.fetchPhoto(for: indexPath) { image in
            cell.stopAnimating()
            cell.configure(with: image)
            cell.configure(with: self.presenter.getLikes(for: indexPath.item))
        }
        return cell
    }
}

