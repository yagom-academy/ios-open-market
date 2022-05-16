//
//  Network.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/10.
//

import Foundation
import UIKit

enum NetworkErorr: Error {
    case unknown
    case jsonError
    case severError
    case urlError
    case imageError
}

final class Cache {
    static let imageCache = NSCache<NSString, UIImage>()
    private init() { }
}

struct NetworkManager<T: Codable> {
    private let session: URLSession
    
    init(session: URLSession = .customSession) {
        self.session = session
    }
    
    func checkServerState(completion: @escaping (Result<String, NetworkErorr>) -> Void) {
        guard let url = EndPoint.serverState(httpMethod: .get).url else {
            completion(.failure(.urlError))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.severError))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(statusCode) else {
                completion(.failure(.severError))
                return
            }
            
            guard let data = data, let text = String(data: data, encoding: .utf8) else {
                completion(.failure(.unknown))
                return
            }
            
            completion(.success(text.trimmingCharacters(in:CharacterSet(charactersIn: "\""))))
        }.resume()
    }
    
    func request(endPoint: EndPoint, completion: @escaping (Result<T, NetworkErorr>) -> Void) {
        guard let url = endPoint.url else {
            completion(.failure(.urlError))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.severError))
                return
            }
            
            guard let responseCode = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(responseCode) else {
                completion(.failure(.severError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
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
        
        if let cacheImage = Cache.imageCache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cacheImage))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.severError))
                return
            }
            
            guard let responseCode = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(responseCode) else {
                completion(.failure(.severError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.imageError))
                return
            }
            
            Cache.imageCache.setObject(image, forKey: url.absoluteString as NSString)
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
