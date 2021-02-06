//
//  ImageLoader.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import Foundation
import UIKit

protocol ImageLoadable: class {
    typealias Handler = (Result<UIImage, Error>) -> Void
    func load(urlString: String, completion: @escaping Handler)
}

class ImageLoader {
    static let shared: ImageLoadable = ImageLoader()
    private var imageCache = NSCache<NSURL, UIImage>()
}

extension ImageLoader: ImageLoadable {
    func load(urlString: String, completion: @escaping Handler) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.convertURL))
            return
        }
        if let cacheData = imageCache.object(forKey: url as NSURL) {
            completion(.success(cacheData))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            if let data = data,
               let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url as NSURL)
                completion(.success(image))
                return
            }
        }
        task.resume()
    }
}
