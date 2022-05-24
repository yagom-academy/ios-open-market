//
//  Network.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/20.
//

import UIKit

final class Network: NetworkAble {
    
    static let shared = Network()
    private let imageCache = NSCache<NSString, UIImage>()
    private let decoder = JSONDecoder()
    let session: URLSessionProtocol
    
    private init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func setImageFromUrl(
        imageUrl: URL,
        completionHandler: @escaping (UIImage) -> Void
    ) -> URLSessionDataTask? {
        let cacheKey = imageUrl.absoluteString as NSString
        
        if let image = imageCache.object(forKey: cacheKey) {
            completionHandler(image)
            return nil
        }
        
        guard let dataTask = requestData(url: imageUrl, completeHandler: { data, error in
            
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            self.imageCache.setObject(image, forKey: cacheKey)
            completionHandler(image)
        }, errorHandler: {
            error in
        }) else {
            return nil
        }
        return dataTask
    }
    
    func setImageFromUrl(
        imageUrlString: String,
        completionHandler: @escaping (UIImage) -> Void
    ) -> URLSessionDataTask? {
        guard let url = URL(string: imageUrlString) else {
            return nil
        }
        return setImageFromUrl(imageUrl: url, completionHandler: completionHandler)
    }
}
