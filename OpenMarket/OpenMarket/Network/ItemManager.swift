//
//  ItemManager.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation

struct ItemManager {
    static func loadData(path: UrlPath, param: UInt, completion: @escaping ((Result<Data?, OpenMarketError>) -> Void)) {
        var url: String?
        switch path {
        case .item:
            url = Config.setUpUrl(method: .get, path: .item, param: param)
        case .items:
            url = Config.setUpUrl(method: .get, path: .items, param: param)
        }
        guard let stringUrl = url, let requestUrl = URL(string: stringUrl) else {
            return
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
    
    static func uploadData(method: HttpMethod, path: UrlPath, item: ItemUploadRequest, param: UInt?, completion: @escaping ((Result<Data?, OpenMarketError>) -> Void)) {
        var url: String?
        switch path {
        case .item:
            if let param = param {
                url = Config.setUpUrl(method: method, path: .item, param: param)
            }
            else {
                url = Config.setUpUrl(method: method, path: .item, param: nil)
            }
        case .items:
            return  completion(.failure(.unknown))
        }
        guard let stringUrl = url, let requestUrl = URL(string: stringUrl) else {
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let jsonData = try? JSONEncoder().encode(item) else {
            return
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
            
            guard let data = data else {
                return completion(.failure(.failGetData))
            }
            return completion(.success(data))
        }
        dataTask.resume()
    }
    
    static func deleteData(path: UrlPath, deleteItem: ItemDeletionRequest, param: UInt, completion: @escaping ((Result<Data?, OpenMarketError>) -> Void)) {
        var url: String?
        switch path {
        case .item:
            url = Config.setUpUrl(method: .delete, path: .item, param: param)
        case .items:
            return  completion(.failure(.unknown))
        }
        guard let stringUrl = url, let requestUrl = URL(string: stringUrl) else {
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = HttpMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let jsonData = try? JSONEncoder().encode(deleteItem) else {
            return
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
            
            guard let data = data else {
                return completion(.failure(.failGetData))
            }
            return completion(.success(data))
        }
        dataTask.resume()
    }
}
