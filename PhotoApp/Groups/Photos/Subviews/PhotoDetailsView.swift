//
//  PhotoDetailsView.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 01.09.2025.
//

import UIKit
import SnapKit

protocol PhotoDetailsViewProtocol: UIView {
    var linkLabel: UILabel { get }
    var activityIndicator: UIActivityIndicatorView { get }
    var photoView: UIImageView { get }
    
    func configure(with model: UnsplashPhoto)
}

final class PhotoDetailsView: UIView, PhotoDetailsViewProtocol {
    
    private enum Drawing {
        static var contentInsets: UIEdgeInsets {
            UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        }
        static var likeTopInset: CGFloat { 16 }
        static var stackSpacing: CGFloat { 4 }
        static var photoHightToWidthDivider: CGFloat { 3 }
        static var likeIconSize: CGSize { CGSize(width: 20, height: 20) }
        static var cornerRadius: CGFloat { 20 }
        static var shadowSize: CGSize { CGSize(width: 10, height: 10) }
    }
    
    // MARK: - UI Elements
    let likeLabel = LabelBuilder()
        .setFont(.systemFont(ofSize: 17, weight: .semibold))
        .build()
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .black
        return indicator
    }()
    let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = Drawing.cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let linkLabel = LabelBuilder()
        .setColor(.systemBlue)
        .setFont(.systemFont(ofSize: 12, weight: .regular))
        .setUserInteractionEnabled(true)
        .build()
    private let shadowView: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = Drawing.shadowSize
        view.layer.shadowRadius = Drawing.shadowSize.height
        view.layer.cornerRadius = Drawing.cornerRadius
        return view
    }()
    private let likeStack = StackFactory.makeStack(
        style: .horizontal(
            spacing: Drawing.stackSpacing,
            alignment: .center
        )
    )
    private let likeIcon = UIImageView(image: UIImage(systemName: "heart.fill"))
    private let nameLabel = LabelBuilder()
        .setFont(.systemFont(ofSize: 15, weight: .semibold))
        .build()
    private let bioLabel = LabelBuilder()
        .setNumberOfLines(0)
        .build()
    private let locationLabel = LabelBuilder().build()
    private let userStack = StackFactory.makeStack(
        style: .vertical(
            spacing: Drawing.stackSpacing * 2,
            alignment: .leading
        )
    )
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with model: UnsplashPhoto) {
        shadowView.layer.shadowColor = CGColor.fromHex(model.color)
        likeLabel.text = "\(model.likes) likes"
        likeIcon.tintColor = .red
        nameLabel.text = "Photographer: \(model.user.name)"
        bioLabel.text = "\(model.user.bio ?? "")"
        locationLabel.text = "Location: \(model.user.location ?? "")"
        linkLabel.text = "\(model.user.links.html)"
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubviews(shadowView, likeStack, userStack, linkLabel)
        shadowView.addSubview(photoView)
        photoView.addSubview(activityIndicator)
        likeStack.addArrangedSubviews(likeIcon, likeLabel)
        userStack.addArrangedSubviews(nameLabel, bioLabel, locationLabel)
    }
    
    private func setupConstraints() {
        let photoHeight = ceil(UIScreen.main.bounds.height / Drawing.photoHightToWidthDivider)
        
        shadowView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(Drawing.contentInsets.top)
            make.horizontalEdges.equalToSuperview().inset(Drawing.contentInsets)
            make.height.equalTo(photoHeight)
        }
        photoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        likeIcon.snp.makeConstraints { make in
            make.size.equalTo(Drawing.likeIconSize)
        }
        likeStack.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom).offset(Drawing.likeTopInset)
            make.trailing.equalToSuperview().inset(Drawing.contentInsets)
        }
        userStack.snp.makeConstraints { make in
            make.top.equalTo(likeStack.snp.bottom).inset(-Drawing.contentInsets.top)
            make.horizontalEdges.equalToSuperview().inset(Drawing.contentInsets)
        }
        linkLabel.snp.makeConstraints { make in
            make.top.equalTo(userStack.snp.bottom).inset(-Drawing.contentInsets.top)
            make.horizontalEdges.equalToSuperview().inset(Drawing.contentInsets)
        }
    }
}
