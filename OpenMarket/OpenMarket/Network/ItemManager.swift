//
//  ItemManager.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation

struct ItemManager {
    typealias resultHandler = (Result<Data?, OpenMarketError>) -> Void
    static let shared = ItemManager()
    private init() {}
    
    func loadData(method: HttpMethod, path: PathOfURL, param: UInt, completion: @escaping resultHandler) {
        guard let requestUrl = makeURL(method: method, path: path, param: param) else {
            return completion(.failure(.failSetUpURL))
        }
        
        guard let request = makeURLRequestWithoutRequestBody(method: method, requestURL: requestUrl) else {
            return completion(.failure(.failMakeURLRequest))
        }
        
        communicateToServerWithDataTask(with: request, completion: completion)
    }
    
    func uploadData(method: HttpMethod, path: PathOfURL, item: ItemToUpload, param: UInt?, completion: @escaping resultHandler) {
        guard let requestUrl = makeURL(method: method, path: path, param: param) else {
            return completion(.failure(.failSetUpURL))
        }
        
        guard let request = makeURLRequestWithRequestBody(method: method, requestURL: requestUrl, item: item) else {
            return completion(.failure(.failMakeURLRequest))
        }
        
        communicateToServerWithDataTask(with: request, completion: completion)
    }
    
    func deleteData(method: HttpMethod, path: PathOfURL, item: ItemToDelete, param: UInt, completion: @escaping resultHandler) {
        guard let requestUrl = makeURL(method: method, path: path, param: param) else {
            return completion(.failure(.failSetUpURL))
        }
        
        guard let request = makeURLRequestWithRequestBody(method: method, requestURL: requestUrl, item: item) else {
            return completion(.failure(.failMakeURLRequest))
        }
        
        communicateToServerWithDataTask(with: request, completion: completion)
    }
    
    func makeURL(method: HttpMethod, path: PathOfURL, param: UInt?) -> URL? {
        var url: URL?
        if let param = param {
            url = NetworkConfig.setUpUrl(method: method, path: path, param: param)
        }
        else {
            url = NetworkConfig.setUpUrl(method: method, path: path, param: nil)
        }
        return url
    }
    
    func makeURLRequestWithoutRequestBody(method: HttpMethod, requestURL: URL) -> URLRequest? {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        return request
    }
    
    func makeURLRequestWithRequestBody<T>(method: HttpMethod, requestURL: URL, item: T) -> URLRequest? {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if method == .delete {
            guard let jsonData = try? JSONEncoder().encode(item as? ItemToDelete) else {
                return nil
            }
            request.httpBody = jsonData
        }
        else if method == .post || method == .patch {
            guard let jsonData = try? JSONEncoder().encode(item as? ItemToUpload) else {
                return nil
            }
            request.httpBody = jsonData
        }
        return request
    }
    
    func communicateToServerWithDataTask(with request: URLRequest, completion: @escaping resultHandler) {
        let session: URLSession = URLSession.shared
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                return completion(.failure(.failTransportData))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.failFetchData))
            }
            
            guard let data = data else {
                return completion(.failure(.failGetData))
            }
            return completion(.success(data))
        }
        dataTask.resume()
    }
    
    func loadItemImage(with url: String, completion: @escaping resultHandler) {
        guard let imageURL = URL(string: url) else {
            return completion(.failure(.failSetUpURL))
        }
        guard let request = makeURLRequestWithoutRequestBody(method: .get, requestURL: imageURL) else {
            return completion(.failure(.failMakeURLRequest))
        }
        communicateToServerWithDataTask(with: request, completion: completion)
    }
}
