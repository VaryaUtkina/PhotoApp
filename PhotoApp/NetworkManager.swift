//
//  NetworkManager.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 19.05.2025.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let accessKey = "18In7aroCRbSeQgW7KsmfkXFeAqwCghU-QbP8cSNrDE"
    
    private init() {}
    
    func fetchPhotos(query: String, completion: @escaping ([UnsplashPhoto]?) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos?query=\(query)&per_page=20"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print(error.localizedDescription)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Статус код: \(httpResponse.statusCode)")
            }
            
            if let data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let prettyJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    
                    if let prettyJsonString = String(data: prettyJsonData, encoding: .utf8) {
                        print("Полученный JSON:\n\(prettyJsonString)")
                    }
                    
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UnsplashPhotoResult.self, from: data)
                    completion(result.results)
                    
                } catch {
                    print("Ошибка декодирования JSON: \(error)")
                    completion(nil)
                }
            }
        }.resume()
    }
    
}
