//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/12.
//

import UIKit

struct URLSessionProvider<T: Decodable> {
    private let session: URLSessionProtocol
    private let cache = NSCache<NSURL, UIImage>()
    
    init (session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData(
        from url: Endpoint,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
            guard let url = url.url else {
                completionHandler(.failure(.urlError))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            request(with: urlRequest, completionHandler: completionHandler)
        }
    
    func request(
        with request: URLRequest,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, urlResponse, error in
            
            guard error == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.statusCodeError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.dataError))
                return
            }
            
            guard let resultData = T.parse(data: data) else {
                completionHandler(.failure(.decodeError))
                return
            }
            
            completionHandler(.success(resultData))
        }
        task.resume()
    }
    
    func fetchImage(
        from url: URL,
        completionHandler: @escaping (Result<UIImage, NetworkError>) -> Void) {
            
            if let cacheImages = cache.object(forKey: url as NSURL) {
                completionHandler(.success(cacheImages))
                return
            }
            
            let task = session.dataTask(with: url) { data, urlResponse, error in
                guard error == nil else {
                    completionHandler(.failure(.clientError))
                    return
                }
                
                guard let httpResponse = urlResponse as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completionHandler(.failure(.statusCodeError))
                    return
                }
                
                guard let data = data else {
                    completionHandler(.failure(.dataError))
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    completionHandler(.failure(.imageError))
                    return
                }
                
                completionHandler(.success(image))
            }
            task.resume()
        }
}


extension UIImageView {
    func fetchImage(url: URL, completion: @escaping (UIImage) -> Void) {

        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            completion(image)
            
        }.resume()
    }
}
