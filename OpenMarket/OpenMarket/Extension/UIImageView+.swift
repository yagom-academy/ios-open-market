//
//  UIImageView+.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/21.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}

extension UIImageView {
    func loadImage(_ urlString: String) {
        let cacheKey = NSString(string: urlString)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage()
                }
                
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                if let data = data, let image = UIImage(data: data) {
                    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                    self?.image = image
                }
            }
        }.resume()
    }
}
