//
//  ViewController.swift
//  PhotoApp
//
//  Created by Варвара Уткина on 19.05.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        networkManager.fetchPhotos(query: "nature") { results in
            results?.forEach({ result in
                print(result.links)
            })
        }
    }


}

