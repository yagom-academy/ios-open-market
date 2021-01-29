//
//  ItemManager.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation

struct ItemManager {
    typealias errorHandler = (Result<Data?, OpenMarketError>) -> Void
    static func loadData(path: PathOfURL, param: UInt, completion: @escaping errorHandler) {
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
    
        var request = URLRequest(url: requestUrl)
        request.httpMethod = HttpMethod.get.rawValue
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                return completion(.failure(.failTransportData))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.failFetchData))
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
    
    static func uploadData(method: HttpMethod, path: PathOfURL, item: ItemUploadRequest, param: UInt?, completion: @escaping errorHandler) {
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
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let jsonData = try? JSONEncoder().encode(item) else {
            return completion(.failure(.failEncode))
        }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionUploadTask = session.uploadTask(with: request, from: jsonData) { (data: Data?, response: URLResponse?,error: Error?) in
            if let error = error {
                return completion(.failure(.failTransportData))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.failUploadData))
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
    
    static func deleteData(path: PathOfURL, deleteItem: ItemDeletionRequest, param: UInt, completion: @escaping errorHandler) {
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
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = HttpMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let jsonData = try? JSONEncoder().encode(deleteItem) else {
            return completion(.failure(.failEncode))
        }
        request.httpBody = jsonData
        
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
