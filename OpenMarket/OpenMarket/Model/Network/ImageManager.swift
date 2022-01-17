//
//  ImageManager.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/13.
//

import UIKit

class ImageManager {
    private let cache = NSCache<NSString, UIImage>()
    static let shared = ImageManager()
    
    private init() {}
    
    func loadCachedData(for key: String) -> UIImage? {
        let itemURL = NSString(string: key)
        return cache.object(forKey: itemURL)
    }
    
    func setCacheData(of image: UIImage, for key: String) {
        let itemURL = NSString(string: key)
        cache.setObject(image, forKey: itemURL)
    }
    
    func downloadImage(
        with url: String,
        completion: @escaping (UIImage) -> Void
    ) {
        let network = Network()
        
        guard let imageURL = URL(string: url) else {
            return
        }
        let imageRequest = URLRequest(url: imageURL)
        
        network.execute(request: imageRequest) { result in
            switch result {
            case .success(let data):
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
