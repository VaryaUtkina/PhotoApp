//
//  PhotoCollectionViewCell.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 28.05.2025.
//

import UIKit
import SnapKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCell"
    
    // MARK: - UI Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .black
        return indicator
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    func configure(with photo: UIImage) {
        imageView.image = photo
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
