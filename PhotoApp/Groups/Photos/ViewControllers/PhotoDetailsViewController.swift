//
//  PhotoDetailsViewController.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 22.05.2025.
//

import UIKit
import SnapKit

final class PhotoDetailsViewController: UIViewController {
    
    private enum Drawing {
        static var topInset: CGFloat { 8 }
        static var likeTopInset: CGFloat { 16 }
        static var horizontalInset: CGFloat { 16 }
        static var stackSpacing: CGFloat { 4 }
        static var photoHightToWidthDivider: CGFloat { 3 }
        static var likeIconSize: CGSize { CGSize(width: 20, height: 20) }
        static var cornerRadius: CGFloat { 20 }
        static var shadowSize: CGSize { CGSize(width: 10, height: 10) }
    }
    
    // MARK: - UI Elements
    private let shadowView: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = Drawing.shadowSize
        view.layer.shadowRadius = Drawing.shadowSize.height
        view.layer.cornerRadius = Drawing.cornerRadius
        return view
    }()
    private let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = Drawing.cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
        .setFont(.systemFont(ofSize: 17, weight: .semibold))
        .build()
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
    private let linkLabel = LabelBuilder()
        .setColor(.systemBlue)
        .setFont(.systemFont(ofSize: 12, weight: .regular))
        .setUserInteractionEnabled(true)
        .build()
    
    // MARK: - Dependencies
    var presenter: PhotoDetailsPresenter!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        fetchFullPhoto()
    }
    
    // MARK: - Actions
    @objc private func handleLinkTap(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: presenter.photoInfo.user.links.html) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Network Methods
    private func fetchFullPhoto() {
        activityIndicator.startAnimating()
        presenter.fetchPhoto()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = Color.background
        
        let photoInfo = presenter.photoInfo
        shadowView.layer.shadowColor = CGColor.fromHex(photoInfo.color)
        likeLabel.text = "\(photoInfo.likes) likes"
        likeIcon.tintColor = .red
        nameLabel.text = "Photographer: \(photoInfo.user.name)"
        bioLabel.text = "\(photoInfo.user.bio ?? "")"
        locationLabel.text = "Location: \(photoInfo.user.location ?? "")"
        linkLabel.text = "\(photoInfo.user.links.html)"
        
        view.addSubviews(shadowView, likeStack, userStack, linkLabel)
        shadowView.addSubview(photoView)
        photoView.addSubview(activityIndicator)
        likeStack.addArrangedSubviews(likeIcon, likeLabel)
        userStack.addArrangedSubviews(nameLabel, bioLabel, locationLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap))
        linkLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Layout
    private func setupConstraints() {
        let photoHeight = ceil(UIScreen.main.bounds.height / Drawing.photoHightToWidthDivider)
        
        shadowView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Drawing.topInset)
            make.horizontalEdges.equalToSuperview().inset(Drawing.horizontalInset)
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
            make.trailing.equalToSuperview().inset(Drawing.horizontalInset)
        }
        userStack.snp.makeConstraints { make in
            make.top.equalTo(likeStack.snp.bottom).inset(-Drawing.topInset)
            make.horizontalEdges.equalToSuperview().inset(Drawing.horizontalInset)
        }
        linkLabel.snp.makeConstraints { make in
            make.top.equalTo(userStack.snp.bottom).inset(-Drawing.topInset)
            make.horizontalEdges.equalToSuperview().inset(Drawing.horizontalInset)
        }
    }
}

// MARK: - Methods for Presenter
extension PhotoDetailsViewController {
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func setImage(_ image: UIImage) {
        photoView.image = image
    }
}
