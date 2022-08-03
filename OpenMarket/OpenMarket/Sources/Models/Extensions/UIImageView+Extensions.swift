//
//  UIImageView+Extensions.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/08/03.
//

import UIKit

extension UIImageView {
    func setImageURL(_ url: String) {
        DispatchQueue.global(qos: .background).async {
            let cachedKey = NSString(string: url)
            let session = URLSession.shared
            
            if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
                DispatchQueue.main.async {
                    self.image = cachedImage
                }
                return
            }
            
            guard let url = URL(string: url) else {
                return
            }
            
            session.dataTask(with: url) { data, result, error in
                guard error == nil else {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = UIImage()
                    }
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    if let data = data,
                       let image = UIImage(data: data) {
                        
                        ImageCacheManager.shared.setObject(
                            image,
                            forKey: cachedKey
                        )
                        self?.image = image
                    }
                }
            }.resume()
        }
    }
}
