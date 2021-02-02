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
    
    private var loadedImages = [URL : UIImage]()
    private var runningRequests = [UUID : URLSessionDataTask]()
}

extension ImageLoader: ImageLoadable {
    func load(urlString: String, completion: @escaping Handler) -> UUID? {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.url))
            return nil
        }
        if let cacheData = loadedImages[url] {
            completion(.success(cacheData))
        }
        let uuid = UUID()
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.runningRequests.removeValue(forKey: uuid) }
            if let data = data,
               let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }
            if let error = error {
                completion(.failure(error))
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

class UIImageLoader {
    static let loader = UIImageLoader()
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
    
    func load(_ urlString: String, for imageView: UIImageView) {
        let token = ImageLoader.shared.load(urlString: urlString) { result in
            defer { self.uuidMap.removeValue(forKey: imageView) }
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch {
                // TODO: handle the error
            }
        }
        
        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            ImageLoader.shared.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}

extension UIImageView {
    func loadImage(at urlString: String) {
        UIImageLoader.loader.load(urlString, for: self)
    }
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}
