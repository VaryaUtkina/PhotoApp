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
    private let photoDetailsView: PhotoDetailsViewProtocol = PhotoDetailsView()
    
    // MARK: - Dependencies
    var presenter: PhotoDetailsPresenter!
    
    // MARK: - View Lifecycle
    override func loadView() {
        super.loadView()
        view = photoDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        photoDetailsView.activityIndicator.startAnimating()
        presenter.fetchPhoto()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = Color.background
        
        let photoInfo = presenter.photoInfo
        photoDetailsView.configure(with: photoInfo)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap))
        photoDetailsView.linkLabel.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Methods for Presenter
extension PhotoDetailsViewController {
    func stopActivityIndicator() {
        photoDetailsView.activityIndicator.stopAnimating()
    }
    
    func setImage(_ image: UIImage) {
        photoDetailsView.photoView.image = image
    }
}
