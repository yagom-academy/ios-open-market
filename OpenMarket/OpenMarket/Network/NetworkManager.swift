//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/10.
//

import UIKit

enum NetworkErorr: Error {
    case dataError
    case jsonError
    case severError
    case urlError
    case imageError
}

struct NetworkManager<T: Codable> {
    private let session: URLSession
    private let cacheManager: CacheManager<UIImage>?
    
    init(session: URLSession = .customSession, imageCache: CacheManager<UIImage>? = nil) {
        self.session = session
        self.cacheManager = imageCache
    }
    
    func checkServerState(completion: @escaping (Result<String, NetworkErorr>) -> Void) {
        guard let urlRequst = EndPoint.serverState(httpMethod: .get).urlRequst else {
            completion(.failure(.urlError))
            return
        }
        
        session.dataTask(with: urlRequst) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    (200..<300).contains(statusCode),
                    error == nil else {
                completion(.failure(.severError))
                return
            }
            
            guard let data = data, let text = String(data: data, encoding: .utf8) else {
                completion(.failure(.dataError))
                return
            }
            
            completion(.success(text.trimmingCharacters(in:CharacterSet(charactersIn: "\""))))
        }.resume()
    }
    
    func request(endPoint: EndPoint, completion: @escaping (Result<T, NetworkErorr>) -> Void) {
        guard let urlRequst = endPoint.urlRequst else {
            completion(.failure(.urlError))
            return
        }
        
        session.dataTask(with: urlRequst) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    (200..<300).contains(statusCode),
                    error == nil else {
                completion(.failure(.severError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .formatted(.dateFormatter)
                
                let result = try jsonDecoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.jsonError))
                return
            }
        }.resume()
    }
    
    func downloadImage(urlString: String?, completion: @escaping (Result<UIImage, NetworkErorr>) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }
        
        if let cacheImage = cacheManager?.get(forKey: url) {
            completion(.success(cacheImage))
            return
        }
        
        let urlRequset = URLRequest(url: url)
        
        session.dataTask(with: urlRequset) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    (200..<300).contains(statusCode),
                    error == nil else {
                completion(.failure(.severError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.imageError))
                return
            }
            
            cacheManager?.set(object: image, forKey: url)
            completion(.success(image))
        }.resume()
    }
}

//MARK: - Extension DateFormatter

private extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SS"
        return dateFormatter
    }()
}

//MARK: - Extension URLSession

private extension URLSession {
    static var customSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForResource = 300
        return URLSession(configuration: configuration)
    }
}
