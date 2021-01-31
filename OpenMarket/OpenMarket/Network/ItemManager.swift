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
        var url: URL?
        switch path {
        case .item:
            url = NetworkConfig.setUpUrl(method: .get, path: .item, param: param)
        case .items:
            url = NetworkConfig.setUpUrl(method: .get, path: .items, param: param)
        }
        guard let requestUrl = url else {
            return completion(.failure(.failSetUpURL))
        }
        
        guard let request = makeURLRequestWithoutRequestBody(method: method, requestURL: requestUrl) else {
            return completion(.failure(.failMakeURLRequest))
        }
        
        communicateToServerWithDataTask(with: request) { result in
            switch result {
            case .success(let data):
                return completion(.success(data))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    func uploadData(method: HttpMethod, path: PathOfURL, item: ItemToUpload, param: UInt?, completion: @escaping resultHandler) {
        var url: URL?
        switch path {
        case .item:
            if let param = param {
                url = NetworkConfig.setUpUrl(method: method, path: .item, param: param)
            }
            else {
                url = NetworkConfig.setUpUrl(method: method, path: .item, param: nil)
            }
        case .items:
            return  completion(.failure(.unknown))
        }
        guard let requestUrl = url else {
            return completion(.failure(.failSetUpURL))
        }
        
        guard let request = makeURLRequestWithRequestBody(method: method, requestURL: requestUrl, item: item) else {
            return completion(.failure(.failMakeURLRequest))
        }
        
        communicateToServerWithDataTask(with: request) { result in
            switch result {
            case .success(let data):
                return completion(.success(data))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    func deleteData(method: HttpMethod, path: PathOfURL, item: ItemToDelete, param: UInt, completion: @escaping resultHandler) {
        var url: URL?
        switch path {
        case .item:
            url = NetworkConfig.setUpUrl(method: .delete, path: .item, param: param)
        case .items:
            return  completion(.failure(.unknown))
        }
        guard let requestUrl = url else {
            return completion(.failure(.failSetUpURL))
        }
        
        guard let request = makeURLRequestWithRequestBody(method: method, requestURL: requestUrl, item: item) else {
            return completion(.failure(.failMakeURLRequest))
        }
        
        communicateToServerWithDataTask(with: request) { result in
            switch result {
            case .success(let data):
                return completion(.success(data))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    private func makeURLRequestWithoutRequestBody(method: HttpMethod, requestURL: URL) -> URLRequest? {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        return request
    }
    
    private func makeURLRequestWithRequestBody<T>(method: HttpMethod, requestURL: URL, item: T) -> URLRequest? {
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
    
    private func communicateToServerWithDataTask(with request: URLRequest, completion: @escaping resultHandler) {
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                return completion(.failure(.failTransportData))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.failDeleteData))
            }
            
            guard let mimeType = httpResponse.mimeType, mimeType == "application/json" else {
                return completion(.failure(.failMatchMimeType))
            }
            
            guard let data = data else {
                return completion(.failure(.failGetData))
            }
            return completion(.success(data))
        }
        dataTask.resume()
    }
}
