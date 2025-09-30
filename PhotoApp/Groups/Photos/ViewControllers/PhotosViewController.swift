//
//  PhotosViewController.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 19.05.2025.
//

import UIKit
import SnapKit

final class PhotosViewController: UIViewController {
    
    private enum Drawing {
        static var photoSpacing: CGFloat { 0 }
    }
    
    // MARK: - UI Elements
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Drawing.photoSpacing
        layout.minimumInteritemSpacing = Drawing.photoSpacing
        
        let cellSide = ceil((UIScreen.main.bounds.width - Drawing.photoSpacing) / 2)
        layout.itemSize = CGSize(width: cellSide, height: cellSide)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier
        )
        collection.contentInset = .zero
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    // MARK: - Dependencies
    let presenter: PhotosPresenter
    
    // MARK: - Initializers
    init(presenter: PhotosPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.fetchPhotos()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = Color.background
        title = "Photos"
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        view.addSubview(photoCollectionView)
        
        photoCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        presenter.numberOfPhotos
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.startAnimating()
        presenter.fetchPhoto(for: indexPath) { image in
            cell.stopAnimating()
            cell.configure(with: image)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.openPhotoInfo(at: indexPath.item)
    }
}

// MARK: - Methods for Presenter
extension PhotosViewController {
    func reloadPhotos(_ photos: [UnsplashPhoto]) {
//        dataSource.update(photos)
        photoCollectionView.reloadData()
    }
}

