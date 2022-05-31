//
//  ImageCache.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/25.
//

import UIKit

protocol Cacheable {
    func loadImage(urlString: String, completionHandler: @escaping (UIImage?) -> Void) -> URLSessionDataTask?
}

final class ImageCache: Cacheable {
    private(set) var imageCache = NSCache<NSString, UIImage>()
    let network: NetworkAble = Network()
    static let shared = ImageCache()
    
    private init() {}
    
    func loadImage(urlString: String, completionHandler: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        if let image = imageCache.object(forKey: urlString as NSString) {
            completionHandler(image)
            return nil
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        let dataTask = network.requestData(url: url) { data, response in
            guard let data = data, let image = UIImage(data: data) else {
                completionHandler(nil)
                return }
            self.imageCache.setObject(image, forKey: urlString as NSString)
            completionHandler(image)
        } errorHandler: { error in
            completionHandler(nil)
        }
        return dataTask
    }
}
