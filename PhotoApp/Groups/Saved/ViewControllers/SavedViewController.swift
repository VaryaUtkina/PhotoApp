//
//  SavedViewController.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 06.10.2025.
//

import UIKit
import SnapKit

final class SavedViewController: UIViewController {
    
    private enum Drawing {
        static var horizontalInset: CGFloat { 20 }
        static var spacing: CGFloat { 0 }
    }
    
    // MARK: - UI Elements
    private let navView = NavBarView()
    private let photoCollection: UICollectionView = {
        let cellSide = floor(UIScreen.main.bounds.width - 2 * Drawing.horizontalInset)
        let layout = UICollectionViewFlowLayout.createLayout(
            lineSpacing: Drawing.spacing,
            interItemSpacing: Drawing.spacing,
            itemSize: CGSize(width: cellSide, height: cellSide)
        )
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(
            SavedPhotoCell.self,
            forCellWithReuseIdentifier: SavedPhotoCell.identifier
        )
        collection.contentInset = .zero
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    private var photos: [UnsplashPhoto] = []
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            photos = Array(UnsplashPhotoResult.getPhotoResults().prefix(4))
            photoCollection.contentInset.top = navView.height - view.safeAreaInsets.top
            photoCollection.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Log.debug("viewWillAppear")
        navView.setTitle("Saved Photos")
    }
}

// MARK: - Setup UI
private extension SavedViewController {
    func setupUI() {
        view.backgroundColor = Color.background
        view.addSubviews(photoCollection, navView)
        
        photoCollection.dataSource = self
        
        navView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        photoCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SavedViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SavedPhotoCell.identifier,
            for: indexPath
        ) as? SavedPhotoCell else { return UICollectionViewCell() }
        guard photos.indices.contains(indexPath.item),
        let image = UIImage(named: "tempImage") else { return UICollectionViewCell() }
        let photo = photos[indexPath.item]
        cell.configure(with: image)
        cell.configure(with: photo.likes)
        return cell
    }
}
