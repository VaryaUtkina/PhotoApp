//
//  UnsplashPhoto.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 19.05.2025.
//

import Foundation

struct UnsplashPhotoResult: Codable {
    let results: [UnsplashPhoto]
    
    static func getPhotoResults() -> [UnsplashPhoto] {
        (0..<10).map { i in
            UnsplashPhotoResult.getModel(with: i + 1)
        }
    }
    
    static func getModel(with number: Int) -> UnsplashPhoto {
        UnsplashPhoto(
            width: 0,
            height: 0,
            color: "#000000",
            likes: 1000,
            urls: UnsplashURLs(full: "", regular: ""),
            user: UnsplashUser(
                location: "Brazil",
                bio: "This is model #\(number) for testing UI and navigation",
                name: "John Dow",
                links: UnsplashLinks(html: "")
            )
        )
    }
}

struct UnsplashPhoto: Codable {
    let width: Int
    let height: Int
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

