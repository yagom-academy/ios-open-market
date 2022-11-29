//
//  ImageParser.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/23.
//

import UIKit.UIImage

enum ImageParser {
    static func parse(_ urlString: String,
                      completion: @escaping (UIImage?) -> Void) {
        if let cacheImage: UIImage = ImageCache.shared.object(forKey: NSString(string: urlString)) {
            completion(cacheImage)
        } else {
            fetchImage(urlString) { (image) in
                if let image: UIImage = image {
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
        guard let url: URL = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data: Data = data,
               let image: UIImage = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
