//
//  ImageManager.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/05.
//

import UIKit

struct ImageManager {
    private let cache = URLCache.shared
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchImage(
        url: String,
        compleHandler: @escaping (Result<UIImage, NetworkError>) -> Void) -> URLSessionTask? {
        guard let url = URL(string: url) else {
            compleHandler(.failure(.invalidURL))
            return nil
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        if let response = cache.cachedResponse(for: request),
           let imageData = UIImage(data: response.data) {
            compleHandler(.success(imageData))
            return nil
        } else {
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let convertResponse = response, let convertData = data {
                    self.cache.storeCachedResponse(
                        CachedURLResponse(
                            response: convertResponse, data: convertData), for: request)
                }
                let result = session.obtainResponseData(
                    data: data, response: response, error: error)
                switch result {
                case .failure(let error):
                    compleHandler(.failure(error))
                    return
                case .success(let data):
                    guard let imageData = UIImage(data: data) else {
                        compleHandler(.failure(.convertImageFailed))
                        return
                    }
                    compleHandler(.success(imageData))
                }
            }
            dataTask.resume()
            return dataTask
        }
    }
}
