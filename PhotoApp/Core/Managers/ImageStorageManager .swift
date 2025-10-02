//
//  ImageStorageManager .swift
//  PhotoApp
//
//  Created by Варвара Уткина on 23.07.2025.
//

import UIKit

final class ImageStorageManager {
    
    static let shared = ImageStorageManager()
    
    // MARK: - Private Properties
    private let fileManager = FileManager.default
    private let imagesDirectory = "stored_images"
    
    private var imagesDirectoryURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(imagesDirectory)
    }
    
    // MARK: - Initializers
    private init() {
        createImagesDirectoryIfNeeded()
    }
    
    // MARK: - Public Methods
    func fetchImages(fileKeys: [String]) -> [UIImage] {
        return fileKeys.compactMap { fileKey in
            fetchImage(forKey: fileKey)
        }
    }
    
    func save(image: UIImage) -> String? {
        let fileKey = UUID().uuidString
        let fileName = "\(fileKey).png"
        
        guard let pngData = image.pngData() else {
            Log.error("Failed to convert image to PNG data")
            return nil
        }
        
        let fileURL = imagesDirectoryURL.appendingPathComponent(fileName)
        do {
            try pngData.write(to: fileURL, options: .atomic)
            return fileKey
        } catch {
            Log.error("Error saving image: \(error)")
            return nil
        }
    }
    
    func deleteImage(forKey fileKey: String) {
        let fileName = "\(fileKey).png"
        let fileURL = imagesDirectoryURL.appendingPathComponent(fileName)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            Log.error("File to delete does not exist: \(fileName)")
            return
        }
        
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            Log.error("Error deleting image for key \(fileKey): \(error)")
        }
    }
    
    func replaceAllImages(with newImages: [UIImage]) -> [String] {
        guard clearAllImages() else { return [] }
        
        var savedKeys: [String] = []
        
        for image in newImages {
            if let key = save(image: image) {
                savedKeys.append(key)
            } else {
                Log.error("Failed to save image during bulk replace")
            }
        }
        
        return savedKeys
    }
    
    
    
    // MARK: - Private Methods
    private func createImagesDirectoryIfNeeded() {
        guard !fileManager.fileExists(atPath: imagesDirectoryURL.path) else { return }
        do {
            try fileManager.createDirectory(
                at: imagesDirectoryURL,
                withIntermediateDirectories: true
            )
        } catch {
            Log.error("createImagesDirectoryIfNeeded: FAILED")
        }
    }
    
    @discardableResult
    private func clearAllImages() -> Bool {
        do {
            try fileManager.removeItem(at: imagesDirectoryURL)
            createImagesDirectoryIfNeeded()
            return true
        } catch {
            Log.error("Error clearing images directory: \(error)")
            return false
        }
    }
    
    private func fetchImage(forKey key: String) -> UIImage? {
        let fileName = "\(key).png"
        let fileURL = imagesDirectoryURL.appendingPathComponent(fileName)
        
        guard let imageData = try? Data(contentsOf: fileURL) else {
            Log.error("Image not found for key: \(key)")
            UserDefaultsManager.shared.removeImage(fileKey: key)
            return nil
        }
        
        return UIImage(data: imageData)
    }
}
