//
//  UserDefaultsManager.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 02.10.2025.
//

import Foundation

import UIKit

final class UserDefaultsManager {
    
    // MARK: - Public Properties
    static let shared = UserDefaultsManager()
    
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let userKey = "user"
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Create Methods
    func createUser() {
        let user = User()
        
        let data = try! JSONEncoder().encode(user)
        userDefaults.set(data, forKey: userKey)
    }
    
    // MARK: - Read Methods
    func getUser() -> User? {
        guard let data = userDefaults.data(forKey: userKey) else {
            return nil
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        } catch {
            Log.error("Ошибка при чтении пользователя пользователя (UserDefaults)")
            return nil
        }
    }
    
    private func saveUser(_ user: User) {
        do {
            let data = try JSONEncoder().encode(user)
            userDefaults.set(data, forKey: userKey)
            Log.debug("user updated: \(user)")
        } catch {
            Log.error("Ошибка при обновлении пользователя (UserDefaults)")
        }
    }
    
    // MARK: - Image Management
    func addImage(fileKey: String) {
        guard var user = getUser() else { return }
        user.imageFileKeys.append(fileKey)
        saveUser(user)
    }
    
    func updateImageList(fileKeys: [String]) {
        guard var user = getUser() else { return }
        user.imageFileKeys = fileKeys
        saveUser(user)
    }
    
    func removeImage(fileKey: String) {
        guard var user = getUser(),
        let index = user.imageFileKeys.firstIndex(of: fileKey) else { return }
        var images = user.imageFileKeys
        images.remove(at: index)
        updateImageList(fileKeys: images)
    }
}
