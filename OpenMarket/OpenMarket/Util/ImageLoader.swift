//
//  ImageLoader.swift
//  OpenMarket
//
//  Created by Dasoll Park on 2021/08/19.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let cache = URLCache.shared
    
    private init() {}
    
    func loadImage(from urlString: String,
                   completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        if let response = cache.cachedResponse(for: request),
           let imageData = UIImage(data: response.data) {
            DispatchQueue.main.async {
                completion(imageData)
            }
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let response = response,
                      let statusCode = (response as? HTTPURLResponse)?.statusCode,
                      (200...299).contains(statusCode) else {
                    print(NetworkError.invalidResponse.localizedDescription)
                    return
                }
                guard let data = data else {
                    print(NetworkError.dataNotFound.localizedDescription)
                    return
                }
                
                guard let imageData = UIImage(data: data) else {
                    print(NetworkError.failToInitializeImage.localizedDescription)
                    return
                }
                
                self.cache.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                
                DispatchQueue.main.async {
                    completion(imageData)
                }
            }.resume()
        }
    }
}
