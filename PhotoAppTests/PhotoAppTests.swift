//
//  PhotoAppTests.swift
//  PhotoAppTests
//
//  Created by Варвара Уткина on 31.05.2025.
//

import Testing
@testable import PhotoApp
import Foundation

struct PhotoAppTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func urlString() throws {
        let query = "query"
        let limit = 20
        let page = 0
        
        
        let components = URLComponents.unsplash
            .photos(with: query)
            .withPage(page, size: limit)
        
        let expected = "https://api.unsplash.com/search/photos?query=\(query)&page=\(page)&per_page=\(limit)"
        
        let result = try #require(components.url)
        
        #expect(result.absoluteString == expected)
    }

}
