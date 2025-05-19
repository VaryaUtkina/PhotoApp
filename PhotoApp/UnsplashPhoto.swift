//
//  UnsplashPhoto.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 19.05.2025.
//

import Foundation

struct UnsplashPhotoResult: Codable {
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Codable {
    let color: String
    let likes: Int
    let links: UnsplashPhotoLinks
    let id: String
}

struct UnsplashPhotoLinks: Codable {
    let html: String
}
