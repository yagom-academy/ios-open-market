//
//  ImageCacheManager.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/17.
//

import UIKit

final class ImageCacheManager<T: Decodable> {
    private let apiService: APIProvider<T>
    private let cache = NSCache<NSURL, UIImage>()
    
    init(apiService: APIProvider<T>) {
        self.apiService = apiService
    }
    
    func loadImage(url: URL, completion: @escaping (UIImage) -> Void) {
        let nsURL = url as NSURL
        
        if let cachedImage = cache.object(forKey: nsURL) {
            completion(cachedImage)
            return
        }
        
        apiService.requestImage(with: url) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: nsURL)
                    completion(image)
                }
            case .failure(_):
                print("썸네일 에러")
            }
        }
    }
}
