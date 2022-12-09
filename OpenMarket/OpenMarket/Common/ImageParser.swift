//
//  ImageParser.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/23.
//

import UIKit.UIImage

struct ImageParser {
    private var fetchImageTask: URLSessionDataTask? = nil
    
    mutating func parse(_ urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString: String = urlString else {
            completion(nil)
            return
        }
        if let cacheImage: UIImage = ImageCache.shared.object(forKey: NSString(string: urlString)) {
            completion(cacheImage)
        } else {
            fetchImage(urlString) { (image) in
                if let image: UIImage = image {
                    ImageCache.shared.setObject(image, forKey: NSString(string: urlString))
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    mutating func cancelTask() {
        fetchImageTask?.cancel()
        fetchImageTask = nil
    }
    
    private mutating func fetchImage(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url: URL = .init(string: urlString) else {
            completion(nil)
            return
        }
        
        fetchImageTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data: Data = data,
               let image: UIImage = .init(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        fetchImageTask?.resume()
    }
}
