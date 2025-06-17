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
        //        static var insets: UIEdgeInsets { UIEdgeInsets(top: <#T##CGFloat#>, left: <#T##CGFloat#>, bottom: <#T##CGFloat#>, right: <#T##CGFloat#>) }
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
    private let likeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Drawing.stackSpacing
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    private let likeIcon = UIImageView(image: UIImage(systemName: "heart.fill"))
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    private let userStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Drawing.stackSpacing * 2
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()
    private let linkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemBlue
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: - Dependencies
    private let networkManager: NetworkManager
    
    // MARK: - Private Properties
    private let photoInfo: UnsplashPhoto
    
    // MARK: - Initializers
    init(photoInfo: UnsplashPhoto, networkManager: NetworkManager) {
        self.photoInfo = photoInfo
        self.networkManager = networkManager
        
        shadowView.layer.shadowColor = CGColor.fromHex(photoInfo.color)
        likeLabel.text = "\(photoInfo.likes) likes"
        likeIcon.tintColor = .red
        nameLabel.text = "Photographer: \(photoInfo.user.name)"
        bioLabel.text = "\(photoInfo.user.bio ?? "")"
        locationLabel.text = "Location: \(photoInfo.user.location ?? "")"
        linkLabel.text = "\(photoInfo.user.links.html)"
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
        setupConstraints()
        fetchFullPhoto()
    }
    
    // MARK: - Actions
    @objc private func handleLinkTap(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: photoInfo.user.links.html) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Network Methods
    private func fetchFullPhoto() {
        activityIndicator.startAnimating()
        networkManager.fetchPhoto(from: photoInfo.urls.full) { result in
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                switch result {
                case .success(let image):
                    self?.photoView.image = image
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = Color.background
        
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
