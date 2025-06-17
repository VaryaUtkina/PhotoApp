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
    let urls: UnsplashURLs
    let user:  UnsplashUser
}

struct UnsplashURLs: Codable {
    let full: String
    let regular: String
}

struct UnsplashUser: Codable {
    let location: String?
    let bio: String?
    let name: String
    let links: UnsplashLinks
}

struct UnsplashLinks: Codable {
    let html: String
}

