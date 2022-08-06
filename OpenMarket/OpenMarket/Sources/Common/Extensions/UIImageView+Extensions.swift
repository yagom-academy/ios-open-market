//
//  UIImageView+Extensions.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/08/03.
//

import UIKit

extension UIImageView {
    
    // MARK: - Actions
    
    func setImageURL(_ url: String) -> URLSessionTask? {
        let cachedKey = NSString(string: url)
        let session = URLSession.shared
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cachedKey) {
            self.image = cachedImage
            
            return nil
        }
        
        guard let url = URL(string: url) else {
            return nil
        }

        let dataTask = session.dataTask(with: url) { data, result, error in
            DispatchQueue.main.async { [weak self] in
                guard error == nil else {
                    self?.image = UIImage()
                    
                    return
                }
                
                if let data = data,
                   let image = UIImage(data: data) {
                    ImageCacheManager.shared.setObject(
                        image,
                        forKey: cachedKey
                    )
                    self?.image = image
                }
            }
        }
        dataTask.resume()
        
        return dataTask
    }
}

