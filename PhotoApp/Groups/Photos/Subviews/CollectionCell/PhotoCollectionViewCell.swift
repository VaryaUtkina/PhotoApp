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
    
    private enum Drawing {
        static var likeInsets: UIEdgeInsets {
            UIEdgeInsets(top: 4, left: 8, bottom: 0, right: 0)
        }
        static var stackSpacing: CGFloat { 4 }
        static var likeIconSize: CGSize { CGSize(width: 14, height: 14) }
    }
    
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
    private let likeStack = StackFactory.makeStack(
        style: .horizontal(
            spacing: Drawing.stackSpacing,
            alignment: .center
        )
    )
    private let likeLabel = LabelBuilder()
        .setFont(.systemFont(ofSize: 12, weight: .medium))
        .build()
    private let likeIcon = UIImageView(image: UIImage(systemName: "heart.fill"))
    
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
    
    func configure(with likes: Int) {
        likeLabel.text = "\(likes) likes "
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        
        guard let formattedLikes = formatter.string(from: NSNumber(value: likes)) else {
            likeLabel.text = "\(likes) likes"
            likeLabel.isHidden = false
            return
        }
        likeLabel.text = "\(formattedLikes) likes"
        likeStack.isHidden = false
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        contentView.addSubviews(imageView, likeStack)
        likeStack.addArrangedSubviews(likeIcon, likeLabel)
        contentView.addSubview(activityIndicator)
        
        likeStack.isHidden = true
        likeStack.backgroundColor = .white.withAlphaComponent(0.7)
        likeStack.layer.cornerRadius = 6
        likeStack.clipsToBounds = true
        likeIcon.tintColor = .red
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        likeStack.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(Drawing.likeInsets)
        }
        likeIcon.snp.makeConstraints { make in
            make.size.equalTo(Drawing.likeIconSize)
        }
    }
}
