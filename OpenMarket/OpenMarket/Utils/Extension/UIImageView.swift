//
//  UIImageView.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/20.
//

import UIKit

struct Cache {
    static let cache = NSCache<NSURL, UIImage>()
    private init() {}
}

extension UIImageView {
    func fetchImage(url: URL, completion: @escaping (UIImage) -> Void) {
        if let cachedImage = Cache.cache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, _ in
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            Cache.cache.setObject(image, forKey: url as NSURL)
            completion(image)
            
        }.resume()
    }
}
