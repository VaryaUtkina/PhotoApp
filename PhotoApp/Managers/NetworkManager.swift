//
//  NetworkManager.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 19.05.2025.
//

import UIKit

// MARK: - Result
extension Result {
    static func parse(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, Error> {
        Result<Data, Error> {
            if let error {
                throw error
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            if let networkError = NetworkError(response: httpResponse) {
                throw networkError
            }
            guard let data else {
                throw NetworkError.noData
            }
            return data
        }
    }
}

extension Result where Success == Data, Failure == Error {
    func decode<T: Decodable>(_ type: T.Type, decoder: JSONDecoder) -> Result<T, Failure> {
        flatMap { data in
            Result<T, Error> {
                try decoder.decode(type.self, from: data)
            }
        }
    }
    
    // TODO: - Как в случае неудачи присвоить именно decodingError
    func decodeTest<T: Decodable>(_ type: T.Type, decoder: JSONDecoder) -> Result<T, Error> {
        flatMap { data in
            do {
                let decodedData = try decoder.decode(type.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(NetworkError.decodingError)
            }
        }
    }
    
    func parseImage(throwing error: Error = NetworkError.noImage) -> Result<UIImage, Failure> {
        flatMap { data in
            if let image = UIImage(data: data) {
                return .success(image)
            }
            return .failure(error)
        }
    }
    
    func setCache(_ cache: NSCache<NSString, NSData>, for urlString: String) -> Result<Data, Error> {
        flatMap { data in
            guard UIImage(data: data) != nil else {
                return .failure(NetworkError.noImage)
            }
            cache.setObject(data as NSData, forKey: NSString(string: urlString))
            return .success(data)
        }
    }
}

// MARK: - NetworkError
enum NetworkError: Error {
    case noData
    case decodingError
    case invalidURL
    case noImage
    case unknown(Error)
    
    init?(response: HTTPURLResponse) {
        switch response.statusCode {
        case 400:
            self = .invalidURL
            
        case 401:
            self = .invalidURL
            
        case 403:
            self = .invalidURL
            
        case 404:
            self = .invalidURL
            
        case 422: // Unprocessable Entity
            self = .invalidURL
            
        case 500, 503:
            self = .invalidURL
            
        default:
            return nil
        }
    }
    
    static func map(_ error: Error) -> NetworkError {
        error as? NetworkError ?? NetworkError.unknown(error)
    }
}

// MARK: - URLComponents
extension URLComponents {
    static var unsplash: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        return components
    }
    
    func withPath(_ path: String) -> URLComponents {
        var copy = self
        copy.path = copy.path
            .appending("/")
            .appending(path)
        return copy
    }
    
    func search(_ path: String) -> URLComponents {
        self.withPath("search")
            .withPath(path)
    }
    
    func photos(with query: String) -> URLComponents {
        self.search("photos")
            .withQueryItem(URLQueryItem(name: "query", value: query))
    }
    
    func withQueryItem(_ item: URLQueryItem) -> URLComponents {
        var copy = self
        guard var current = copy.queryItems else {
            copy.queryItems = [item]
            return copy
        }
        current.append(item)
        copy.queryItems = current
        return copy
    }
    
    func withQueryItems(_ items: URLQueryItem...) -> URLComponents {
        items.reduce(self) { components, item in
            components.withQueryItem(item)
        }
    }
    
    func withPage(_ page: Int, size: Int) -> URLComponents {
        self.withQueryItems(
            URLQueryItem(name: "page", value: page.description),
            URLQueryItem(name: "per_page", value: size.description)
        )
    }
}

// MARK: - NetworkManager
final class NetworkManager {
    
    // MARK: - Static Properties
    static let shared = NetworkManager()
    
    // MARK: - Private Properties
    private let accessKey = "18In7aroCRbSeQgW7KsmfkXFeAqwCghU-QbP8cSNrDE"
    private let imageFetcher: URLSession
    private let cache = NSCache<NSString, NSData>()
    
    // MARK: - Initializers
    private init() {
        let imageConfig = URLSessionConfiguration.default
        imageConfig.timeoutIntervalForRequest = 30
        imageConfig.timeoutIntervalForResource = 60
        imageConfig.urlCache = URLCache(
            memoryCapacity: 1024 * 20,
            diskCapacity: 1024 * 20
        )
        self.imageFetcher = URLSession(configuration: imageConfig)
    }
    
    // MARK: - Public Methods
    func fetchPhotos(
        query: String,
        page: Int = 0,
        limit: Int = 20,
        completion: @escaping ((Result<[UnsplashPhoto], NetworkError>) -> Void)
    ) {
        let components = URLComponents.unsplash
            .photos(with: query)
            .withPage(page, size: limit)
        
        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            let result = Result<[UnsplashPhoto], NetworkError>
                .parse(data: data, response: response, error: error)
                .decode(UnsplashPhotoResult.self, decoder: JSONDecoder())
                .map(\.results)
                .mapError(NetworkError.map(_:))
            
            completion(result)
            
        }.resume()
    }
    
    func fetchPhoto(
        from urlString: String,
        completion: @escaping ((Result<UIImage, NetworkError>) -> Void)
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        //        if let cachedData = cache.object(forKey: NSString(string: urlString)) as Data?,
        //           let image = UIImage(data: cachedData) {
        //            completion(.success(image))
        //            return
        //        }
        
        imageFetcher.dataTask(with: url) { data, response, error in
            let result = Result<Data, NetworkError>
                .parse(data: data, response: response, error: error)
                .setCache(self.cache, for: urlString)
                .parseImage()
                .mapError(NetworkError.map(_:))
            
            completion(result)
        }.resume()
    }
}
