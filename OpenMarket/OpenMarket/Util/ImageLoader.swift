//
//  ImageLoader.swift
//  OpenMarket
//
//  Created by Dasoll Park on 2021/08/19.
//

import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private init() {}
    
    func loadImage(from urlString: String,
                   completion: @escaping (UIImage) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(statusCode) else { return }
            guard let data = data else { return }
            
            guard let imageData = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completion(imageData)
            }
        }.resume()
    }
}
