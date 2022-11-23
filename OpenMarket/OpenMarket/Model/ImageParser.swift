//
//  ImageParser.swift
//  OpenMarket
//
//  Created by Ayaan on 2022/11/23.
//

import UIKit.UIImage

enum ImageParser {
    static func parse(_ urlString: String,
                      completion: @escaping (UIImage?) -> Void) {
        if let cacheImage = ImageCache.shared.object(forKey: NSString(string: urlString)) {
            completion(cacheImage)
        } else {
            fetchImage(urlString) { (image) in
                if let image = image {
                    ImageCache.shared.setObject(image,
                                                forKey: NSString(string: urlString))
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    private static func fetchImage(_ urlString: String,
                                   completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            }
        }.resume()
    }
}
