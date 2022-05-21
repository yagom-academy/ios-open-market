//
//  ImageManager.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/20.
//

import UIKit

class ImageManager {
    static let shared = ImageManager(imageCache: CacheManager())
    
    private let session: URLSession
    private let cacheManager: CacheManager<UIImage>
    
    private init(session: URLSession = .customSession, imageCache: CacheManager<UIImage>) {
        self.session = session
        self.cacheManager = imageCache
    }
    
    func clearCache() {
        cacheManager.clear()
    }
    
    func downloadImage(urlString: String?, completion: @escaping (Result<UIImage, NetworkErorr>) -> Void) -> URLSessionDataTask? {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return nil
        }
        
        if let cacheImage = cacheManager.get(forKey: url) {
            completion(.success(cacheImage))
            return nil
        }
        
        let urlRequset = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequset) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    (200..<300).contains(statusCode),
                    error == nil else {
                completion(.failure(.severError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.imageError))
                return
            }
            
            self.cacheManager.set(object: image, forKey: url)
            completion(.success(image))
        }
        task.resume()
        
        return task
    }
}
