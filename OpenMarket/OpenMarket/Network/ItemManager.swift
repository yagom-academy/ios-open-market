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
    private let boundary = UUID().uuidString
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
    
    func uploadData(method: HttpMethod, path: PathOfURL, item: ItemToUpload, param: UInt? = nil, completion: @escaping resultHandler) {
        guard let requestURL = makeURL(method: method, path: path, param: param) else {
            return completion(.failure(.failSetUpURL))
        }
        
        guard let request = makeURLRequestWithRequestBody(method: method, requestURL: requestURL, item: item) else {
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
    
    func makeURL(method: HttpMethod, path: PathOfURL, param: UInt? = nil) -> URL? {
        var url: URL?
        url = NetworkConfig.setUpUrl(method: method, path: path, param: param)
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
        
        if method == .delete {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            guard let jsonData = try? JSONEncoder().encode(item as? ItemToDelete) else {
                return nil
            }
            request.httpBody = jsonData
        }
        else if method == .post || method == .patch {
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            guard let httpBody = makeMultipartFormDataBody(with: item) else {
                return nil
            }
            request.httpBody = httpBody
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
    
    func makeMultipartFormDataBody<T>(with item: T) -> Data? {
        var body = Data()
        guard let item = item as? ItemToUpload else {
            return nil
        }
        for (key, value) in item.parameters {
            if case Optional<Any>.none = value {
                continue
            }
            if let data = value as? [Data] {
                body.append(createHttpBodyWithDataFormat(key: key, value: data))
            }
            else {
                body.append(createHttpBody(key: key, value: value))
            }
        }
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    private func createHttpBodyWithDataFormat(key: String, value: [Data]) -> Data {
        var body = Data()
        for image in value {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)[]\"; filename=\"\(Date()).jpeg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(image)
            body.append("\r\n")
        }
        return body
    }
    
    private func createHttpBody(key: String, value: Any) -> Data {
        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        if let data = value as? String {
            body.append(data)
        }
        else if let data = value as? UInt {
            body.append(String(data))
        }
        body.append("\r\n")
        
        return body
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
