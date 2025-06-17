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
    private let networkManager: NetworkManager
    
    // MARK: - Initializers
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    private let searchQuery = "nature"
    private var photoInfos: [UnsplashPhoto] = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        fetchPhotos()
    }
    
    // MARK: - Network Methods
    private func fetchPhotos() {
        networkManager.fetchPhotos(query:searchQuery) { [weak self] result in
            switch result {
            case .success(let results):
                DispatchQueue.main.async {
                    self?.photoInfos = results
                    self?.photoCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = Color.background
        title = "Photos"
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        view.addSubview(photoCollectionView)
    }
    
    // MARK: - Layout
    private func setupConstraints() {
        photoCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoInfos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        let photoInfo = photoInfos[indexPath.item]
        cell.startAnimating()
        networkManager.fetchPhoto(from: photoInfo.urls.regular) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    cell.configure(with: image)
                case .failure(_):
                    let errorImage = UIImage(systemName: "photo.on.rectangle.angled")
                    cell.configure(with: errorImage ?? UIImage())
                }
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    //    func collectionView(
    //        _ collectionView: UICollectionView,
    //        layout collectionViewLayout: UICollectionViewLayout,
    //        sizeForItemAt indexPath: IndexPath
    //    ) -> CGSize {
    //        CGSize(
    //            width: ceil(collectionView.bounds.width / 2),
    //            height: ceil(collectionView.bounds.width / 2)
    //        )
    //    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard photoInfos.indices.contains(indexPath.row) else {
            assertionFailure()
            return
        }
        let photoInfo = photoInfos[indexPath.row]
        let detailsVC = PhotoDetailsViewController(photoInfo: photoInfo, networkManager: networkManager)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

