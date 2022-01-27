//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/04.
//

import Foundation
import UIKit.UIImage

struct URLSessionProvider {
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func request(_ service: OpenMarketService,
                 completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let urlRequest = service.urlRequest else {
            completionHandler(.failure(URLSessionProviderError.urlRequestError))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            }
            
            guard let httpRespose = response as? HTTPURLResponse,
                  (200...299).contains(httpRespose.statusCode) else {
                return completionHandler(.failure(URLSessionProviderError.statusError))
            }
            guard let data = data else {
                return completionHandler(.failure(URLSessionProviderError.dataError))
            }
            return completionHandler(.success(data))
        }
        task.resume()
    }
    
    func request<T: Decodable>(_ service: OpenMarketService,
                               completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = service.urlRequest else {
            completionHandler(.failure(URLSessionProviderError.urlRequestError))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(URLSessionProviderError.statusError))
            }
            
            guard let data = data else {
                return completionHandler(.failure(URLSessionProviderError.dataError))
            }
            
            guard let decoded = try? JSONDecoder.shared.decode(T.self, from: data) else {
                return completionHandler(.failure(URLSessionProviderError.decodingError))
            }
            
            return completionHandler(.success(decoded))
        }
        task.resume()
    }
    
    func requestImage(from URLString: String,
                      completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: URLString) else {
            completionHandler(.failure(URLSessionProviderError.urlRequestError))
            return
        }
        
        let task = session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(URLSessionProviderError.statusError))
            }
            
            guard let data = data else {
                return completionHandler(.failure(URLSessionProviderError.dataError))
            }
            
            guard let image = UIImage(data: data) else {
                return completionHandler(.failure(URLSessionProviderError.decodingError))
            }
            
            return completionHandler(.success(image))
        }
        task.resume()
    }
}

enum URLSessionProviderError: String, LocalizedError {
    
    case statusError = "HTTP 통신 중 문제가 발생하였습니다"
    case urlRequestError = "URLRequest 처리 중 문제가 발생하였습니다"
    case dataError = "HTTP 응답 데이터 처리 중 문제가 발생하였습니다"
    case decodingError = "JSON 데이터 디코딩 중 문제가 발생하였습니다"
    
    var errorDescription: String? {
        self.rawValue
    }
    
}
