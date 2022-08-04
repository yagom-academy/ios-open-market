//
//  UIImageView+Extension.swift
//  OpenMarket
//
//  Created by Brad on 2022/08/04.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageURL(_ url: String) {
        
        let cacheKey = NSString(string: url)
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async {
            if let url = URL(string: url) {
                URLSession.shared.dataTask(with: url) { data, res, err in
                    if let _ = err {
                        DispatchQueue.main.async {
                            self.image = UIImage()
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data,
                           let image = UIImage(data: data) {
                            self.image = image
                        }
                    }
                }.resume()
            }
        }
    }
}
