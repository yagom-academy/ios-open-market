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
    func load(urlString: String, completion: @escaping Handler) -> UUID?
    func cancelLoad(_ uuid: UUID)
}

class ImageLoader {
    static let shared: ImageLoadable = ImageLoader()
    
    private var imageCache = NSCache<NSURL, UIImage>()
    private var runningRequests = [UUID : URLSessionDataTask]()
}

extension ImageLoader: ImageLoadable {
    func load(urlString: String, completion: @escaping Handler) -> UUID? {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.url))
            return nil
        }
        if let cacheData = imageCache.object(forKey: url as NSURL) {
            completion(.success(cacheData))
            return nil
        }
        let uuid = UUID()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.runningRequests.removeValue(forKey: uuid) }
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
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
