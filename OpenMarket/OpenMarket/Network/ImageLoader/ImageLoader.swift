//
//  ImageLoader.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/02.
//

import Foundation

protocol ImageLoadable: class {
    typealias Handler = (Result<Data, Error>) -> Void
    func load(urlString: String, completion: @escaping Handler)
}

class ImageLoader {
    static let shared: ImageLoadable = ImageLoader()
}

extension ImageLoader: ImageLoadable {
    func load(urlString: String, completion: @escaping Handler) {
        if let cacheData = ImageCache.shared.find(urlString) {
            completion(.success(cacheData))
        } else {
            self.requestImage(urlString: urlString) { result in
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

extension ImageLoader {
    func requestImage(urlString: String, completion: @escaping Handler) {
        FetchImage().getResource(url: urlString) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
